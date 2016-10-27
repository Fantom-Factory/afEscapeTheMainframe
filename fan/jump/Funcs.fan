
class Funcs {
	
	private const Int	z0	:=	 2.pow(0)
	private const Int	z1	:=	 2.pow(1)
	private const Int	z2	:=	 2.pow(2)
	private const Int	x1	:=	 2.pow(3)
	private const Int	x2	:=	 2.pow(4)
	private const Int	x3	:=	 2.pow(5)
	private const Int	y1	:=	 2.pow(6)
	private const Int	y2	:=	 2.pow(7)
	private const Int	y3	:=	 2.pow(8)
	
	private const Int:Int[]	allowedBlocks := [
		x1 + y1 + z0	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y1 + z0	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z0	: [      3, 4, 5, 6, 7, 8, 9, 10],

		x1 + y1 + z1	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y1 + z1	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z1	: [            5, 6, 7, 8, 9, 10],

		x1 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],

		x1 + y2 + z0	: [   2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y2 + z0	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y2 + z0	: [         4, 5, 6, 7, 8, 9, 10],

		x1 + y2 + z1	: [   2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y2 + z1	: [         4, 5, 6, 7, 8, 9, 10],
		x3 + y2 + z1	: [               6, 7, 8, 9, 10],

		x1 + y3 + z0	: [            5, 6, 7, 8, 9, 10],
		x2 + y3 + z0	: [            5, 6, 7, 8, 9, 10],
		x3 + y3 + z0	: [               6, 7, 8, 9, 10],	// note, need to increase shortest dist

		x1 + y3 + z1	: [   2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y3 + z1	: [         4, 5, 6, 7, 8, 9, 10],
		x3 + y3 + z1	: [               6, 7, 8, 9, 10],
	]
	
	private Int:Int[] allowedLevels
	
	new make() {
		allowedLevels := Int:Int[][:] { it.ordered = true }
		10.times |l| {
			allowedLevels[l] = allowedBlocks.keys.findAll { allowedBlocks[it].contains(l+1) }
		}
		this.allowedLevels = allowedLevels
	}
	
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
	
	
	Block funcBlock(GameData data, Int level, Float distance) {
		key	:= allowedLevels[level - 1].random
		
//		key = x3 + y3 + z0
		
		x := 0
		if (key.and(x1) != 0)	x = 0
		if (key.and(x2) != 0)	x = 1
		if (key.and(x3) != 0)	x = 2
		
		y := 0
		if (key.and(y1) != 0)	y = 0
		if (key.and(y2) != 0)	y = 1
		if (key.and(y3) != 0)	y = 2

		z := 0
		if (key.and(z0) != 0)	z = 0
		if (key.and(z1) != 0)	z = 1
		if (key.and(z2) != 0)	z = 2

		b := Models.block(data, x, y) {
			it.y += (z * 50f)
		}
		
		return b
	}
}
