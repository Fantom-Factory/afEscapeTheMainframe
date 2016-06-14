
const class Sin {
	private static const Int		min		:=    0
	private static const Int		max		:= 1000
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

	static Float sin(Float angle) {
		idx := ((angle - angle.floor) * max).toInt
		return sinTable[idx]
	}

	static Float cos(Float angle) {
		idx := ((angle - angle.floor) * max).toInt
		return cosTable[idx.toInt]
	}
}


const class SinOld {
	private const Float[] sinTable 
	private const Float[] cosTable

	private new make() {
		sinTable := [,] {capacity=360}
		cosTable := [,] {capacity=360}
		360.times |i| {
			sinTable.add( i.toFloat.toRadians.sin )
			cosTable.add( i.toFloat.toRadians.cos )
		}
		this.sinTable = sinTable.toImmutable
		this.cosTable = cosTable.toImmutable
	}

	Int sin(Int val, Int angle) {
		while (angle <  0)		angle += 360
		while (angle >= 360)	angle -= 360
		return (sinTable[angle] * val).toInt
	}

	Int cos(Int val, Int angle) {
		while (angle <  0)		angle += 360
		while (angle >= 360)	angle -= 360
		return (cosTable[angle] * val).toInt
	}
}