using afIoc
using gfx

** Stoopid apple devices won't play any sound until we play one inside a touch event...
@Js
class TouchScreen : GameSeg {
	
	@Inject	private |->App|		app
	@Inject	private FannyImages	images
	@Inject	private FannySounds	sounds
	@Inject	private Screen		screen
			private Int			tick

	new make(|This| f) { f(this) }
	
	override This onInit() {
		screen.mouseDownFunc = |->| {
			screen.mouseDownFunc = null
			sounds.insertCoin.play
			app().showTitles
		}
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		g2d.clear(Models.bgColour)

		g2d.offsetCentre
		g2d.brush = Models.brand_lightBlue
		g2d.fillRoundRect(-75, -75, 150, 150, 20, 20)
		
		if (tick < 25) {
			g2d.brush = Color.white
			g2d.fillPolygon(Point2d[
				Point2d(-35f, -35f),
				Point2d( 35f,   0f),
				Point2d(-35f,  35f),
			])
		}
		
		tick++
		if (tick > 45)
			tick = 0
		
		g2d.offset(0, 0)
		g2d.drawFont16Centred("Click to Play",	15 * 16)
	}
}
