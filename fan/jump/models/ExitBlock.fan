using gfx::Rect

@Js
class ExitBlock : Model {
	GameData	data
	Bool		killMe
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data		
	}

	override Void anim() {
		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
	}
}
