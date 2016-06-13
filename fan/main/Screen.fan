using fwt
using gfx
using afIoc

class Screen : Canvas {

	@Inject private EventHub	eventHub
					Key:Bool	keys		:= Key:Bool[:]

	new make(|This| in) {
		in(this)
		doubleBuffered = true
		
		onKeyDown.add { this.keyDown(it) }
		onKeyUp	 .add { this.keyUp	(it) }
	}
	
	private Void keyDown(Event e) {
		keys[e.key.primary] = true
	}
	
	private Void keyUp(Event e) {
		keys.remove(e.key.primary)
	}
	
	override Void onPaint(Graphics graphics) {
		g := Gfx(graphics)
//		g.clear
		eventHub.fireEvent(DemoEvents#draw, [g])
	}	
}
