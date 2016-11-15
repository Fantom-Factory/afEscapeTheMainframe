using gfx::Color
using gfx::Rect

@Js
class FannyExplo : Model {
	GameData 			data
	Int					col		:=  0xFF
	FannyExploSquare[]	squares
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
	}
	
	override Void draw(Gfx3d g3d) {
		squares.each { it.draw(g3d) }
	}
	
	override Void anim() {
		rgb	:= (data.level == 11)
			? 0x00FF00
			: 0xFF0000.or(col.shiftl( 8)).or(col)
		
		blood	:= Fill(Color((Int) rgb))
		col		= 0x22.max(col - 5)

		squares.each {
			it.anim
			it.drawables[0] = blood
		}
	}
}

@Js
class FannyExploSquare : Model {
	Point3d	movementVector

	const Int	index
	const Float	gravity		:= -0.7f
	const Float	groundZero	:= -150f
	
	new make(|This| in) : super(in) { }

	override Void anim() {		
		thing := movementVector
		x += thing.x
		y += thing.y
		z += thing.z
		
		if (yMin < groundZero) {
			y -= thing.y
			movementVector = movementVector.scale(1f, -1f, 1f)
		}
		
		movementVector = movementVector.translate(-0.2f, gravity, 0f)
	}
	
	override Void draw(Gfx3d g3d) {
		drawModel(g3d)
	}

	// speed optimisation - knock out the camera rotation
	Void drawModel(Gfx3d g3d) {
		if (x < -800f)	return

		pts2d := (Point3d[]) points.map {
			it	.rotate(this.ax, this.ay, this.az)
				.translate(this.x, this.y, this.z + 500f)
				.project(300f)
		}
		
		g2d := g3d.g2d
		if ((g2d.ox + pts2d.first.x) < -20f)	return
		if ((g2d.oy + pts2d.first.y) < -20f)	return

		drawables.each { it.draw(g3d, pts2d) }
	}
}
