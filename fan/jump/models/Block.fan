using gfx::Rect

class Block : Model {
	Float	w
	Float	h
	
	new make(|This| in) : super(in) {
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
	}

	Rect collisionRect() {
		x := (Float) points.map { it.x + this.x }.min
		y := (Float) points.map { it.y + this.y }.max
		return Rect(x.toInt, y.toInt, w.toInt, h.toInt)
	}
}
