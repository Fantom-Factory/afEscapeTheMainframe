using afIoc

@Js
class HiScores {
		static const Int	maxNoOfPositions	:= 100
		static const Int	maxNameSize			:= 12

	@Inject	private	|->App|			app
	@Inject	private	Log				log
	@Inject	private	HiScoreOnline	hiScoresOnline
					HiScore[]		hiScores	:= HiScore[,]
					Bool			editing		:= false
	
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
		hiScoresOnline.loadScores
	}
	
	Void saveScore(HiScore hiScore) {
		hiScoresOnline.saveScore(hiScore)
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
