
@Js
const class Funcs {
	
	static const Int	z0	:=	 2.pow( 0)
	static const Int	z1	:=	 2.pow( 1)
	static const Int	z2	:=	 2.pow( 2)
	static const Int	z3	:=	 2.pow( 3)
	static const Int	z4	:=	 2.pow( 4)
	static const Int	x1	:=	 2.pow( 5)
	static const Int	x2	:=	 2.pow( 6)
	static const Int	x3	:=	 2.pow( 7)
	static const Int	y1	:=	 2.pow( 8)
	static const Int	y2	:=	 2.pow( 9)
	static const Int	y3	:=	 2.pow(10)
	static const Int	y4	:=	 2.pow(11)
	static const Int	mo	:=	 2.pow(12)
	
	private const Int:Int[]	allowedBlocks := [
		x1 + y1 + z0	: [1, 2, 3, 4, 5, 6, 7, 8       ],
		x2 + y1 + z0	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z0	: [      3, 4, 5, 6, 7, 8, 9, 10],

		x1 + y1 + z0+mo	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y1 + z0+mo	: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z0+mo	: [      3, 4, 5, 6, 7, 8, 9, 10],

		x1 + y1 + z1	: [      3, 4, 5, 6, 7, 8       ],
		x2 + y1 + z1	: [         4, 5, 6, 7, 8, 9, 10],
		x3 + y1 + z1	: [            5, 6, 7, 8, 9, 10],

		x1 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7          ],
		x2 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7, 8       ],
		x3 + y1 + z2	: [1, 2, 3, 4, 5, 6, 7, 8, 9    ],

		x1 + y2 + z0	: [   2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y2 + z0	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y2 + z0	: [         4, 5, 6, 7, 8, 9, 10],

		x1 + y2 + z0+mo	: [   2, 3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y2 + z0+mo	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x3 + y2 + z0+mo	: [         4, 5, 6, 7, 8, 9, 10],

		x1 + y2 + z1	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y2 + z1	: [         4, 5, 6, 7, 8, 9, 10],
		x3 + y2 + z1	: [            5, 6, 7, 8, 9, 10],

		x1 + y3 + z0	: [         4, 5, 6, 7, 8, 9, 10],
		x2 + y3 + z0	: [            5, 6, 7, 8, 9, 10],
		x3 + y3 + z0	: [               6, 7, 8, 9, 10],	// note, need to increase shortest dist

		x1 + y3 + z1	: [      3, 4, 5, 6, 7, 8, 9, 10],
		x2 + y3 + z1	: [         4, 5, 6, 7, 8, 9, 10],
		x3 + y3 + z1	: [               6, 7, 8, 9, 10],

		x1 + y4 + z0	: [                  7, 8, 9, 10],

		x1 + y1 + z0+z3	: [               6, 7, 8, 9, 10],
		x2 + y1 + z0+z3	: [                  7, 8, 9, 10],
	mo+	x1 + y1 + z0+z3	: [                     8, 9, 10],
	mo+	x2 + y1 + z0+z3	: [                        9, 10],

		x1 + y1 + z0+z4	: [               6, 7, 8, 9, 10],
		x2 + y1 + z0+z4	: [                  7, 8, 9, 10],
	mo+	x1 + y1 + z0+z4	: [                     8, 9, 10],
	mo+	x2 + y1 + z0+z4	: [                        9, 10],

		x1 + y2 + z0+z4	: [                  7, 8, 9, 10],
		x2 + y2 + z0+z4	: [                     8, 9, 10],
	mo+	x1 + y2 + z0+z4	: [                        9, 10],
	mo+	x2 + y2 + z0+z4	: [                           10],
	]
	
	private const Int:Int[] allowedLevels
	
	new make() {
		allowedLevels := Int:Int[][:] { it.ordered = true }
		10.times |l| {
			allowedLevels[l] = allowedBlocks.keys.findAll { allowedBlocks[it].contains(l+1) }
		}
		this.allowedLevels = allowedLevels
	}
	
	Float funcfloorSpeed(Int level) {
//		((25f - 8f) * (level / 9f)) + 8f
		10f + (level * 0.5f)
	}
	
	Bool funcNewBlock(Int level, Float distance, Float speed) {
		level--

		shortest :=   550f - (level *  15)				// 550  -> 400  
		longest	 := (1500f - (level * 175)).max(500f)	// 1500 -> 500 
		
		if (distance < shortest)
			return false
		if (distance > longest)
			return true

		maxNoOfSteps := (longest - shortest) / speed
		probability	 := 1 / maxNoOfSteps
		return Float.random < probability
	}
	
	
	Block[] funcBlock(GameData data, Int level, Float distance, Block? lastBlock) {
		
		allowedLevels := allowedLevels[9.min(level - 1)]
		
		lastKey := lastBlock?.blockKey
		if (lastKey != null) {
			// if we've just done a high jump, don't immediately follow it with another
			if (distance < 475f && (lastKey.and(y2) != 0 || lastKey.and(y3) != 0 || lastKey.and(y4) != 0) && lastKey.and(z0) != 0)
				allowedLevels = allowedLevels.exclude { (it.and(y2) != 0 || it.and(y3) != 0 || it.and(y4) != 0) && it.and(z0) != 0 }
//				allowedLevels = allowedLevels.exclude { it.and(z0) != 0 }

			if (distance < 425f && lastKey.and(z0) != 0)
				allowedLevels = allowedLevels.exclude { it.and(z0) != 0 }

			if (distance < 425f && lastKey.and(z1) != 0)
				allowedLevels = allowedLevels.exclude { (it.and(y2) != 0 || it.and(y3) != 0 || it.and(y4) != 0) && it.and(z0) != 0 }
		}
		
		key	:= allowedLevels.random
		
//		key = x3 + y3 + z0
		
		x := 0
		if (key.and(x1) != 0)	x = 0
		if (key.and(x2) != 0)	x = 1
		if (key.and(x3) != 0)	x = 2
		
		y := 0
		if (key.and(y1) != 0)	y = 0
		if (key.and(y2) != 0)	y = 1
		if (key.and(y3) != 0)	y = 2
		if (key.and(y4) != 0)	y = 3

		z := 0
		if (key.and(z0) != 0)	z = 0
		if (key.and(z1) != 0)	z = 1
		if (key.and(z2) != 0)	z = 2

		if (z == 2 && y == 1 && level >= 3 && Float.random > 0.5f)
			y = 2
		
		b1 := Models.block(data, x, y) {
			it.y += (z * 50f)
			it.score = (x+1) * (y+1)
			it.blockKey = key
		}
		
		hasZ3 := (key.and(z3) != 0)
		hasZ4 := (key.and(z4) != 0)
		newZ  := hasZ3 ? 4 : 5
		b2 := (!hasZ3 && !hasZ4) ? null : Models.block(data, x, hasZ3 ? y+1 : y) {
			it.y += (newZ * 50f)
			it.score = (x+1) * (y+1)
			it.blockKey = key			
		}
		
		// ensure fat blocks aren't grouped closer together
		data.distSinceLastBlock = -(x * 50f)
		
		return b2 == null ? [b1] : [b1, b2]
	}
	
	BonusCube? funcBonusCube(GameData data, Block block) {
		if (++data.cubeBlocks < 6)
			return null
		
		data.cubeBlocks = 0
					
		blockKey := block.blockKey
		
		x := 0
		if (blockKey.and(Funcs.x1) != 0)	x = 0
		if (blockKey.and(Funcs.x2) != 0)	x = 1
		if (blockKey.and(Funcs.x3) != 0)	x = 2

		h := 0
		if (blockKey.and(Funcs.y1) != 0)	h += 1
		if (blockKey.and(Funcs.y2) != 0)	h += 2
		if (blockKey.and(Funcs.y3) != 0)	h += 3
		if (blockKey.and(Funcs.y4) != 0)	h += 4

		if (blockKey.and(Funcs.z1) != 0) {
			h += 1
			if (h > 4) h = 0
			if (h > 3 && x > 0) h = 0
		}
		if (blockKey.and(Funcs.z2) != 0) {
			h += 2
			if (h > 4) h = 0
			if (h > 3 && x > 0) h = 0
		}

		
		cx := block.x + (x * 50f / 2f)
		cy := -150f + (h * 50f)
		if (h != 0) cy += 80f
		
		bonus := Models.bonusCube(data, cx, cy)
		block.bonusCube = bonus
		return bonus
	}
	
	const Int[] jumpLevels	:= [
		10, 
		20  + ((10) * 3 / 4),  
		30  + ((20 + 10) * 3 / 4), 
		40  + ((30 + 20 + 10) * 3 / 4), 
		50  + ((40 + 30 + 20 + 10) * 3 / 4), 
		60  + ((50 + 40 + 30 + 20 + 10) * 3 / 4), 
		70  + ((60 + 50 + 40 + 30 + 20 + 10) * 3 / 4), 
		80  + ((70 + 60 + 50 + 40 + 30 + 20 + 10) * 3 / 4), 
		90  + ((80 + 70 + 60 + 50 + 40 + 30 + 20 + 10) * 3 / 4), 
		100 + ((90 + 80 + 70 + 60 + 50 + 40 + 30 + 20 + 10) * 3 / 4),
	]

	Int funcLevel(GameData data) {
		if (data.training)	return data.level

		if (data.level == 11) return 11
		return data.blocksJumpedInLevel > jumpLevels[data.level-1] ? data.level + 1 : data.level
	}
}
