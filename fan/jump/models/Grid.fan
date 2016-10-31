
class Grid : Model {
	private GameData data

	new make(GameData data, |This| in) : super(in) {
		this.data  = data
	}
	
	override Void anim() {
		x -= data.floorSpeed
		if (x < -240f) {
			x += 240f
		}
	}
}
