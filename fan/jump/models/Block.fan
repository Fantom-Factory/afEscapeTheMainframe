using gfx::Rect

class Block : Model {
	GameData	data
	Float	w
	Float	h
	Bool	killMe
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
		
//		this.y = ((-2..3).random * 50f) - 25f
		this.x = 1000f

		this.y = ((-2..0).random * 50f) - 25f
//		this.y = (2 * 50f) - 25f
//		this.y = (-1 * 50f) - 25f
	}

	override This anim() {
		x -= data.floorSpeed
		if (x < -900f) {
			killMe = true
			data.newBlockPlease = true
		}
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
