using afConcurrent
using afButter
using afIoc
using afIocConfig
using concurrent
using dom

@Js
abstract class HiScoreOnline {
	
	@Config { id="hiScores.apiUrl" }
			Uri				hiScroreApiUrl
	@Inject	|->App|			app
	@Inject	|->HiScores|	hiScores
	@Inject	Log				log
	private Duration?		lastSync

	new make(|This| f) { f(this) }

	Void loadScores() {
		if (app().offlineMode) {
			log.info("Not downloading Hi-Scores - offline mode Activated")
			return
		}
		
		if (lastSync != null && (Duration.now - lastSync) < 2min) {
			lastSyncDur := Duration.now - lastSync
			log.info("Not downloading Hi-Scores - last sync only ${lastSyncDur.toLocale} ago")
			return
		}
		
		hiScoreUrl	:= hiScroreApiUrl + gameName
		doLoadScores(hiScoreUrl)
	}

	Void saveScore(HiScore hiScore) {
		if (app().offlineMode) {
			log.info("Not uploading Hi-Score - offline mode Activated (${hiScore})")
			return
		}
		
		hiScoreUrl	:= hiScroreApiUrl + gameName.plusSlash + encodeUri(hiScore.name).plusSlash + encodeUri(hiScore.score.toStr)
		doSaveScore(hiScoreUrl, hiScore)
	}

	Void setScores(Obj?[]? serverScores) {
		newScores := serverScores.map |Str:Obj? json -> HiScore| {
			HiScore {
				it.when		= DateTime.fromIso(json["when"])
				it.name		= json["name"]
				it.score	= json["score"]
			}
		}
		app().offline = false

		log.info("Downloaded ${newScores.size} Hi-Scores from ${gameName}")
		
		if (hiScores().editing) {
			log.warn("Ignoring server scores - User is entering a new Hi-Score")
			return
		}
		
		hiScores().hiScores = newScores
		lastSync = Duration.now	
	}
	
	abstract Void doLoadScores(Uri hiScoreUrl)
	abstract Void doSaveScore(Uri hiScoreUrl, HiScore his)
	
	private Uri gameName() {
		encodeUri("${typeof.pod.name}-${typeof.pod.version}")
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
			Butter.churnOut.get(hiScoreUrl).body.jsonList
		}
	}

	override Void doSaveScore(Uri hiScoreUrl, HiScore his) {
		doStuff |->Obj?| {
			Butter.churnOut.putStr(hiScoreUrl, "").body.jsonList
		}
	}
	
	private Void doStuff(|->Obj?| func) {
		safeThis := Unsafe(this)
		safeApp  := Unsafe(app())
		hiScoreThread.async |->| {
			that := (HiScoreOnline) safeThis.val
			try {
				serverScores := func()
				that.setScores(serverScores)
				
			} catch (Err err) {
				that.log.err("Hi-Score Server Error - ${err.typeof} - ${err.msg}")
				app := (App) safeApp.val
				app.offline = true
			}
		}
	}
}

//@Js
//class HiScoreOnlineJs : HiScoreOnline {
//	
//	new make(|This| f) : super.make(f) { }
//
//	override Void loadScores() { }
//	override Void saveScore(HiScore his) { }
//}
