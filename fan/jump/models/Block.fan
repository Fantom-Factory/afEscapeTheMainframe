using gfx::Rect

class Block : Model {
	GameData	data
	Float		w
	Float		h
	Bool		killMe
	Int			score
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
		
		this.y = -25f - 50f - 50f
		this.x = 1000f
	}

	override This anim() {
		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
		return this
	}
	
	Rect collisionRect() {
		x := (Float) points.map { it.x }.min
		y := (Float) points.map { it.y }.max
		return Rect((this.x + x).toInt, -(this.y + y).toInt, w.toInt, h.toInt)
	}
	
	Float xMax() {
		xs := (Float[]) points.map { it.x }
		return xs.max + this.x
	}
}
