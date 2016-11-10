using gfx::Color
using gfx::Rect

@Js
class BonusExplo : Model {
	GameData 			data
	Bool				killMe
	Int					killMeCountdown
	BonusExploSquare[]	squares
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
	}
	
	override Void draw(Gfx3d g3d) {
		g3d.drawAll |->| {
			squares.each { it.draw(g3d) }
		}
	}
	
	override Void anim() {
		squares.each { it.anim }
		if (killMeCountdown++ > 50)
			killMe = true
	}
}

@Js
class BonusExploSquare : Model {
	GameData 	data
	Float		force	:= 10f
	Float		size	:= 0.25f
	Point3d		movementVector

	new make(GameData data, |This| in) : super(in) {
		this.data = data
	}

	override Void anim() {		
		thing := movementVector.scale(force)
		x += thing.x
		y += thing.y
		z += thing.z
		
		x -= (data.floorSpeed / 2)
		
		force = 0f.max(force - 0.18f)
		
		az += 0.04f
				
		points = [
			Point3d(-100f,  100f, -100f),
			Point3d( 100f,  100f, -100f),
			Point3d( 100f, -100f, -100f),
			Point3d(-100f, -100f, -100f),
			Point3d(-100f,  100f,  100f),
			Point3d( 100f,  100f,  100f),
			Point3d( 100f, -100f,  100f),
			Point3d(-100f, -100f,  100f),
		]
		scale(size)
		size -= 0.005f
	}
}
