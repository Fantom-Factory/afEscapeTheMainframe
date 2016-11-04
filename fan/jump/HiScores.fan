using afConcurrent
using afButter
using afIoc
using afIocConfig

@Js
class HiScores {
	static const Int	maxNoOfPositions	:= 100
	static const Int	maxNameSize			:= 12

	@Inject	private	|->App|			app
	@Inject	private	Log				log
	
//	@Inject { id="hiScores" }	
//			private Synchronized	hiScoreThread
	
	@Config { id="hiScores.apiUrl" }
			private	Uri				hiScroreApiUrl
	
			private HiScore[]		hiScores	:= HiScore[,]
			private Duration?		lastSync
					Bool			editing
	
	new make(|This| f) {
		f(this)
		
		// set some default scores - in case we go offline
		hiScores = (0..<maxNoOfPositions-10).toList.map |i->HiScore| {
			HiScore {
				name	= "Slimer"
				score	= 1_000 - (i * 10)
			}
		}
	}
	
	@Operator
	HiScore? getSafe(Int i) {
		hiScores.getSafe(i)
	}
	
	@Operator
	HiScore[] getRange(Range r) {
		hiScores[r]
	}
	
	Int size() {
		hiScores.size
	}
	
	Bool isHiScore(Int score) {
		size < maxNoOfPositions || score >= hiScores.last.score
	}
	
	Int newPosition(Int score) {
		pos := hiScores.eachrWhile |his, i| {
			score >= his.score ? null : i + 1
		} ?: 0
		
		hiScores.insert(pos, HiScore {
			it.name	= ""
			it.score = score
		})
		
		if (size > maxNoOfPositions)
			hiScores.removeAt(-1)
		
		return pos
	}

	Void loadScores() {
		if (Env.cur.runtime == "js")
			return
		
//		if (app().offlineMode) {
//			log.info("Not downloading Hi-Scores - offline mode Activated")
//			return
//		}
//		
//		if (lastSync != null && (Duration.now - lastSync) < 2min) {
//			lastSyncDur := Duration.now - lastSync
//			log.info("Not downloading Hi-Scores - last sync only ${lastSyncDur.toLocale} ago")
//			return
//		}
//		
//		safeThis := Unsafe(this)
//		safeApp  := Unsafe(app())
//		hiScoreThread.async |->| {
//			that := (HiScores) safeThis.val
//			try {
//				pod			:= HiScores#.pod
//				gameParam	:= encodeUri("${pod.name}-${pod.version}")
//				hiScoreUrl	:= that.hiScroreApiUrl + gameParam
//				serverScores := Butter.churnOut.get(hiScoreUrl).body.jsonList
//				
//				newScores := serverScores.map |Str:Obj? json -> HiScore| {
//					HiScore {
//						it.when		= DateTime.fromIso(json["when"])
//						it.name		= json["name"]
//						it.score	= json["score"]
//					}
//				}
//				app := (App) safeApp.val
//				app.offline = false
//
//				that.log.info("Downloaded ${newScores.size} Hi-Scores from ${gameParam}")
//				
//				if (that.editing) {
//					that.log.warn("Ignoring server scores - User is entering a new Hi-Score")
//					return
//				}
//				
//				that.hiScores = newScores
//				that.lastSync = Duration.now
//				
//			} catch (Err err) {
//				that.log.err("Hi-Score Server Error - ${err.typeof} - ${err.msg}")
//				app := (App) safeApp.val
//				app.offline = true
//			}
//		}
	}
	
	Void saveScore(HiScore his) {
		if (Env.cur.runtime == "js")
			return

//		if (app().offlineMode) {
//			log.info("Offline Mode Activated - not uploading Hi-Score: ${his}")
//			return
//		}
//		
//		safeThis := Unsafe(this)
//		safeApp  := Unsafe(app())
//		safeHis	 := Unsafe(his)
//		hiScoreThread.async |->| {
//			that := (HiScores) safeThis.val
//			hiScore := (HiScore) safeHis.val
//			try {
//				pod			:= HiScores#.pod
//				gameParam	:= encodeUri("${pod.name}-${pod.version}")
//				hiScoreUrl	:= that.hiScroreApiUrl + gameParam.plusSlash + encodeUri(hiScore.name).plusSlash + encodeUri(hiScore.score.toStr)
//				
//				serverScores := Butter.churnOut.putStr(hiScoreUrl, "").body.jsonList
//				
//				newScores := serverScores.map |Str:Obj? json -> HiScore| {
//					HiScore {
//						it.when		= DateTime.fromIso(json["when"])
//						it.name		= json["name"]
//						it.score	= json["score"]
//					}
//				}
//				app := (App) safeApp.val
//				app.offline = false
//				
//				that.log.info("Uploaded '${hiScore}' to ${gameParam}")
//
//				that.log.info("Downloaded ${newScores.size} Hi-Scores from ${gameParam}")
//
//				if (that.editing) {
//					that.log.warn("Ignoring server scores - User is entering a new Hi-Score")
//					return
//				}
//				
//				that.hiScores = newScores
//				that.lastSync = Duration.now
//				
//			} catch (Err err) {
//				that.log.err("Hi-Score Server Error - ${err.typeof} - ${err.msg}")
//				app := (App) safeApp.val
//				app.offline = true
//			}
//		}
	}
	
	static const Int[] delims := ":/?#[]@\\".chars

	// Encode the Str *to* URI standard form
	// see http://fantom.org/sidewalk/topic/2357
	static Uri encodeUri(Str str) {
		buf := StrBuf(str.size + 8) // allow for 8 escapes
		str.chars.each |char| {
			if (delims.contains(char))
				buf.addChar('\\')
			buf.addChar(char)
		}
	    return buf.toStr.toUri
	}
}


@Js
class HiScore {
	DateTime	when	:= DateTime.now(1sec)
	Str			name
	Int			score
	
	new make(|This| f) { f(this) }
	
	Str toScreenStr(Int i) {
		(i == 100 ? "" : " ") + i.toStr.justr(2) + ") " + score.toStr.justr(5) + name.padl(13, '.') + " "
	}
	
	override Str toStr() {
		"${name} - ${score}"
	}
}
