
const class Sin {
	private static const Int		min		:=     0
	private static const Int		max		:= 5_000
	private static const Float[]	sinTable 
	private static const Float[]	cosTable
	
	
	static {
		sinTable := [,] { capacity = Sin.max }
		cosTable := [,] { capacity = Sin.max }
		max.times |i| {
			rad := (i.toFloat * 360 / max).toRadians
			sinTable.add( rad.sin )
			cosTable.add( rad.cos )
		}
		Sin.sinTable = sinTable.toImmutable
		Sin.cosTable = cosTable.toImmutable
	}

	// seems to be wrong somewhere somehow
//	static {
//		start := Duration.now
//		sinTable := Float[,] { capacity = Sin.max }
//		cosTable := Float[,] { capacity = Sin.max }
//		
//		// we assume that a sin calculation is much more expensive than list copying
//		// actually, for a max of 5000, there's only 2ms in it! (17ms vs 15ms)
//		(max / 4).times |i| {
//			rad := (i.toFloat * 360 / max).toRadians
//			sinTable.add( rad.sin )
//		}
//		(max / 4).times |i| {
//			idx := (max / 4) - i - 1
//			sinTable.add(sinTable[idx])
//			cosTable.add(sinTable[idx])
//		}
//		(max / 2).times |i| {
//			sinTable.add(-sinTable[i])
//		}
//		(max * 3 / 4).times |i| {
//			cosTable.add(sinTable[i])
//		}
//		Sin.sinTable = sinTable.toImmutable
//		Sin.cosTable = cosTable.toImmutable
//	}

	** From 0 - 1
	static Float sin(Float angle) {
		idx := ((angle - angle.floor) * max).toInt % max
		return sinTable[idx]
	}

	** From 0 - 1
	static Float cos(Float angle) {
		idx := ((angle - angle.floor) * max).toInt % max
		return cosTable[idx]
	}
}
