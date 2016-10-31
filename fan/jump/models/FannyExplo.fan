using gfx::Color
using gfx::Rect

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
		rgb		:= 0xFF0000.or(col.shiftl(8)).or(col)
		blood	:= Fill(Color(rgb))
		col		= 0x22.max(col - 5)

		squares.each {
			it.anim
			it.drawables[0] = blood
		}
	}
}

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
}
