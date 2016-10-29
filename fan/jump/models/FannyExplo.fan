using gfx::Rect

class FannyExplo : Model {
	GameData data

	FannyExploSquare[]	squares
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
	}
	
	override This draw(Gfx3d g3d) {
		squares.each { it.draw(g3d) }
		return this
	}
	
	override This anim() {
		squares.each { it.anim }
		return this
	}
}

class FannyExploSquare : Model {
	Point3d	movementVector
	Float	force

	new make(|This| in) : super(in) { }
		
	override This anim() {
		thing := movementVector * force
		x += thing.x
		y += thing.y
		z += thing.z
		return this
	}
}
