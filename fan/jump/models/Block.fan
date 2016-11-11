using gfx::Rect

@Js
class Block : Model {
	GameData	data
	Float		w
	Float		h
	Bool		killMe
	Int			score
	Int			blockKey
	BonusCube?	bonusCube
	Drawable[]	drawablesDup
	BlockCache	blockCache
	
	new make(GameData data, BlockCache blockCache, |This| in) : super(in) {
		this.data = data
		this.blockCache = blockCache
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
		
		this.y = -25f - 50f - 50f
		this.x = 1000f
		this.drawablesDup = drawables.dup
	}

	override Void anim() {
		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
	}
	
	override Void draw(Gfx3d g3d) {
		drawables = drawablesDup.dup
		drawables.removeAt(x < 0f ? 3 : 4)
		drawables.removeAt(y > 0f ? 4 : 5)
		
		pts2d := points.map {
			blockCache.get(it.x + this.x, it.y + this.y, it.z)
		}
		drawables.each { it.draw(g3d, pts2d) }
	}
}

@Js
class BlockCache {
	private Bool 			inited
	private Int:Point3d[]	data1	:= Int:Point3d[][:]
	private Int:Point3d[]	data2	:= Int:Point3d[][:]
	
	Void init() {
		if (inited) return
		
		g3d := Gfx3d(null).lookAtDef
		
		8.times |i| {
			y := -25f + (i * 50f) -25f - 50f - 50f
			
			1125.times |j| {
				x := j.toFloat
				pt1 := g3d.to2d(Point3d(x, y, -175f))
				pt2 := g3d.to2d(Point3d(x, y,  175f))

				data1.getOrAdd(y.toInt) { Point3d[,] { it.capacity = 1125 } }.add(pt1)
				data2.getOrAdd(y.toInt) { Point3d[,] { it.capacity = 1125 } }.add(pt2)
			}
		}
		
		inited = true
	}
	
	Point3d get(Float x, Float y, Float z) {
		dat := z < 0f ? data1[y.toInt][x.toInt.abs] : data2[y.toInt][x.toInt.abs]
		return x < 0f ? Point3d(-dat.x, dat.y, dat.z) : dat
	}
}
