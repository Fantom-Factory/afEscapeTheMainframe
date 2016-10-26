
class Funcs {
	
	Bool funcNewBlock(Int level, Float distance, Float speed) {
		level--

		shortest := 1500f - (level * 75)	// 1500 ->  750 
		longest	 := 2000f - (level * 75)	// 2000 -> 1250 

		if (distance < shortest)
			return false
		if (distance > longest)
			return true

		maxNoOfSteps := (longest - shortest) / speed
		probability	 := 1 / maxNoOfSteps
		return Float.random < probability
	}
}
