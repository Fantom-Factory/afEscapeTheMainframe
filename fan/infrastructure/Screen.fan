using fwt
using gfx
using afIoc

class Screen : Canvas {

	@Inject private EventHub	eventHub
					Key:Bool	keys		:= Key:Bool[:]

			private Image		font8x8		:= Image(`fan://afDemo/res/XenonFont8x8.png`)
			private Image		font16x16	:= Image(`fan://afDemo/res/XenonFont16x16.png`)

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
		g := Gfx(graphics) {
			it.font8x8		= this.font8x8
			it.font16x16	= this.font16x16
		}
//		g.clear
		eventHub.fireEvent(DemoEvents#onDraw, [g])
	}	
}
