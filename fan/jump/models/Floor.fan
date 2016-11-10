
@Js
class Floor : Model {
	private GameData data

	new make(GameData data, |This| in) : super(in) {
		this.data  = data
	}
	
	override Void anim() {
		x -= data.floorSpeed
		if (x < -240f)
			x += 240f
	}
}

@Js
class FloorFake : Model {
	private GameData	data
	private FloorCache	floorCache

	new make(GameData data, FloorCache floorCache, |This| in) : super(in) {
		this.data 		= data
		this.floorCache = floorCache
	}
	
	override Void anim() {
		x -= data.floorSpeed
		if (x <= -240f)
			x +=  240f
	}

	override Void draw(Gfx3d g3d) {
		pts2d := floorCache[x]
		drawables.each { it.draw(g3d, pts2d) }
	}
}

@Js
class FloorCache {
	private Bool 		inited
	private Point3d[][]	data	:= Point3d[][,]
	
	Void init() {
		if (inited) return
		
		g3d		:= Gfx3d(null).lookAtDef
		floor	:= Models.fakeFloor(GameData(), this)
		
		240.times |->| {
			data.add(g3d.modelTo2d(floor))
			floor.x -= 1f
		}
		
		inited = true
	}
	
	@Operator
	Point3d[] get(Float x) {
		data[x.toInt.abs]
	}
}