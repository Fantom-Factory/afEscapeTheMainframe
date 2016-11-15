
@Js
class BonusCube : Model {
	
	private GameData	data
			Bool		killMe
			Bool		drawn
	const	Bool		drawCollisionRect

	new make(GameData data, |This| in) : super(in) {
		this.data  = data
	}

	override Void draw(Gfx3d g3d) {
		if (drawn) return
		
		drawModel(g3d)
		drawn = true

		if (drawCollisionRect) {
			g3d.edge = gfx::Color.red
			g3d.drawRect(collisionRect, z)
		}
	}

	override Void anim() {
		ax += 1f/100f
		ay += 1f/280f
		az -= 1f/500f

		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
	}
	
	// speed optimisation - knock out the camera rotation
	Void drawModel(Gfx3d g3d) {		
		pts2d := points.map {
			it	.rotate(this.ax, this.ay, this.az)
				.translate(this.x, this.y, this.z + 500f)
				.project(300f)
		}
		drawables.each { it.draw(g3d, pts2d) }
	}
}
