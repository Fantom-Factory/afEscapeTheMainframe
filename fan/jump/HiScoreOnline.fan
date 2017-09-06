using afIoc
using concurrent
using dom
using util::JsonInStream

@Js
abstract class HiScoreOnline {
	
			Uri				hiScroreApiUrl	:= `http://hiscores.fantomfactory.org/`	
	@Inject	|->App|			app
	@Inject	|->HiScores|	hiScores
	@Inject	Log				log
	private Duration?		lastSync

	new make(|This| f) {
		f(this)
		
		if (Env.cur.vars["env"]?.lower == "development") 
			hiScroreApiUrl = `http://localhost:8080/` 
	}

	Void loadScores() {
		if (app().offlineMode) {
			log.debug("Not downloading Hi-Scores - offline mode Activated")
			return
		}
		
		if (lastSync != null && (Duration.now - lastSync) < 2min) {
			lastSyncDur := Duration.now - lastSync
			log.debug("Not downloading Hi-Scores - last sync only ${lastSyncDur.toLocale} ago")
			return
		}
		
		hiScoreUrl	:= hiScroreApiUrl + gameName
		doLoadScores(hiScoreUrl)
	}

	Void saveScore(HiScore hiScore, Int level) {
		if (app().offlineMode) {
			log.info("Not uploading Hi-Score - offline mode Activated (${hiScore})")
			return
		}
		
		hiScoreUrl	:= (hiScroreApiUrl + gameName.plusSlash + encodeUri(hiScore.name).plusSlash + encodeUri(hiScore.score.toStr)).plusQuery(["level":level.toStr])
		doSaveScore(hiScoreUrl, hiScore)
	}

	Void setScores(App app, HiScores hiScores, Obj?[]? serverScores) {
		newScores := serverScores.map |Str:Obj? json -> HiScore| {
			HiScore {
				it.when		= DateTime.fromIso(json["when"])
				it.name		= json["name"]
				it.score	= json["score"]
			}
		}
		app.offline = false

		log.debug("Downloaded ${newScores.size} Hi-Scores from ${gameName}")
		
		if (hiScores.editing) {
			log.warn("Ignoring server scores - User is entering a new Hi-Score")
			return
		}
		
		hiScores.hiScores = newScores
		lastSync = Duration.now	
	}
	
	abstract Void doLoadScores(Uri hiScoreUrl)
	abstract Void doSaveScore(Uri hiScoreUrl, HiScore his)
	
	Uri gameName() {
		encodeUri("afEscapeTheMainframe")	// this is now fixed
	}
	
	private static const Int[] delims := ":/?#[]@\\".chars

	// Encode the Str *to* URI standard form
	// see http://fantom.org/sidewalk/topic/2357
	private static Uri encodeUri(Str str) {
		buf := StrBuf(str.size + 8) // allow for 8 escapes
		str.chars.each |char| {
			if (delims.contains(char))
				buf.addChar('\\')
			buf.addChar(char)
		}
	    return buf.toStr.toUri
	}
}

class HiScoreOnlineJava : HiScoreOnline {
	private Synchronized	hiScoreThread

	new make(|This| f) : super.make(f) {
		actorPool := ActorPool() { it.name = "Hi-Scores" }
		hiScoreThread = Synchronized(actorPool)
	}

	override Void doLoadScores(Uri hiScoreUrl) {
		doStuff |->Obj?| {
			wc := web::WebClient(hiScoreUrl) {
				it.reqMethod = "GET"
				it.reqHeaders["X-afEscapeTheMainframe.platform"] = "Desktop"
			}.writeReq.readRes
			if (wc.resCode != 200)
				throw IOErr("Hi-Score Server Error - Status ${wc.resCode}")
			
			return JsonInStream(wc.resStr.in).readJson
		}
	}

	override Void doSaveScore(Uri hiScoreUrl, HiScore his) {
		logFunc := Unsafe(|->| { log.info("Uploaded ${his} to ${gameName}") })
		doStuff |->Obj?| {
			wc := web::WebClient(hiScoreUrl) {
				it.reqMethod = "PUT"
				it.reqHeaders["X-afEscapeTheMainframe.platform"] = "Desktop"
			}.writeReq.readRes
			if (wc.resCode != 200 && wc.resCode != 201)
				throw IOErr("Hi-Score Server Error - Status ${wc.resCode}")

			json := JsonInStream(wc.resStr.in).readJson
			logFunc.val->call
			return json
		}
	}
	
	private Void doStuff(|->Obj?| func) {
		safeThis := Unsafe(this)
		safeApp  := Unsafe(app())
		safeHis  := Unsafe(hiScores())
		hiScoreThread.async |->| {
			that := (HiScoreOnline) safeThis.val
			app	 := (App) safeApp.val
			his	 := (HiScores) safeHis.val
			try {
				serverScores := func()
				that.setScores(app, his, serverScores)
				
			} catch (Err err) {
				that.log.err("Hi-Score Server Error - ${err.typeof} - ${err.msg}")
				app.offline = true
			}
		}
	}
}

@Js
class HiScoreOnlineJs : HiScoreOnline {

	new make(|This| f) : super.make(f) { }

	override Void doLoadScores(Uri hiScoreUrl) {
		platform := Actor.locals["afEscapeTheMainframe.platform"] ?: "Web"
		echo("Platform = $platform")
		echo(Actor.locals)
		HttpReq {
			it.uri = hiScoreUrl
			it.headers["X-afEscapeTheMainframe.platform"] = platform
		}.get |res| {
			if (res.status != 200) {
				app().offline = true
				return log.err("Hi-Score Server Error - Status ${res.status}")
			}
			
			serverScores := JsonInStream(res.content.in).readJson
			setScores(app(), hiScores(), serverScores)
		}
	}

	override Void doSaveScore(Uri hiScoreUrl, HiScore his) {
		platform := Actor.locals["afEscapeTheMainframe.platform"] ?: "Web"
		HttpReq {
			it.uri = hiScoreUrl
			it.headers["X-afEscapeTheMainframe.platform"] = platform
		}.send("PUT", null) |res| {
			if (res.status != 200 && res.status != 201) {
				app().offline = true
				return log.err("Hi-Score Server Error - Status ${res.status}")
			}
			
			log.info("Uploaded [${his}] to ${gameName}")
			serverScores := JsonInStream(res.content.in).readJson
			setScores(app(), hiScores(), serverScores)
		}
	}
}
