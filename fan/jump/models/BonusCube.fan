
@Js
class BonusCube : Model {
	
	private GameData	data
			Bool		killMe
			Bool		drawn

	new make(GameData data, |This| in) : super(in) {
		this.data  = data
	}

	override Void draw(Gfx3d g3d) {
		if (drawn) return
		
		g3d.drawModel(this)
		drawn = true

//		g3d.edge = gfx::Color.red
//		g3d.drawRect(collisionRect, z)
	}

	override Void anim() {
		ax += 1f/100f
//		ay += 1f/280f	// ax spins it enough!
//		az -= 1f/500f

		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
	}
}
