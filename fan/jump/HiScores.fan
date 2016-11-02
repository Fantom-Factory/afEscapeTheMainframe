
class HiScores {
	
	HiScore[]	hiScores
	
	new make() {
		hiScores = (0..<100).toList.map |i->HiScore| {
			HiScore {
				name	= "SlimerDude"
				score	= 10_000 - (i * 100)
			}
		}
	}
	
	@Operator
	HiScore get(Int i) {
		hiScores[i]
	}
}


class HiScore {
	DateTime	when	:= DateTime.now(1sec)
	Str			name
	Int			score
	
	new make(|This| f) { f(this) }
	
	Str toScreenStr(Int i) {
		(i == 100 ? "" : " ") + i.toStr.justr(2) + ") " + score.toStr.justr(5) + name.padl(13, '.') + " "
	}
}