
class BonusCube : Model {
	
	private GameData	data
			Bool		killMe

	new make(GameData data, |This| in) : super(in) {
		this.data  = data
	}

	override This anim() {
		ax += 1f/100f
		ay += 1f/280f
		az -= 1f/500f
		
		x -= data.floorSpeed
		if (x < -1000f)
			killMe = true
		return this
	}
}
