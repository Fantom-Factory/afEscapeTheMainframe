using gfx::Rect

@Js
class Block : Model {
	GameData	data
	Float		w
	Float		h
	Bool		killMe
	Int			score
	Int			blockKey
	BonusCube?	bonusCube
	Drawable[]	drawablesDup
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
		
		this.y = -25f - 50f - 50f
		this.x = 1000f
		this.drawablesDup = drawables.dup
	}

	override Void anim() {
		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
	}
	
	override Void draw(Gfx3d g3d) {
		drawables = drawablesDup.dup
		drawables.removeAt(x < 0f ? 3 : 4)
		drawables.removeAt(y > 0f ? 4 : 5)

		g3d.drawModel(this)
	}
}
