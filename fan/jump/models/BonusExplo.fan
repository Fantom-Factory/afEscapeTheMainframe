using gfx::Color
using gfx::Rect

class BonusExplo : Model {
	GameData 			data
	Bool				killMe
	Int					killMeCountdown
	BonusExploSquare[]	squares
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
	}
	
	override Void draw(Gfx3d g3d) {
		squares.each { it.draw(g3d) }
	}
	
	override Void anim() {
		squares.each { it.anim }
		if (killMeCountdown++ > 100)
			killMe = true
	}
}

class BonusExploSquare : Model {
	Float	force	:= 10f
	Point3d	movementVector

	new make(|This| in) : super(in) { }

	override Void anim() {		
		thing := movementVector.scale(force)
		x += thing.x
		y += thing.y
		z += thing.z
		
		force -= 0.1f
	}
}
