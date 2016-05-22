using fwt
using gfx
using afIoc

class Screen : Canvas {

	@Inject private EventHub eventHub

	new make(|This| in) {
		in(this)
		doubleBuffered = true
	}
	
	override Void onPaint(Graphics graphics) {
		g := Gfx(graphics)
		g.clear
		eventHub.fireEvent(DemoEvents#draw, [g])
	}	
}
