
@Js
const class SinOld {
	
	static const SinOld instance := SinOld()
	
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
