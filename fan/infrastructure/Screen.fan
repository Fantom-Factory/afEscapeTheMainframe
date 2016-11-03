using fwt
using gfx
using afIoc

class Screen : Canvas {

	@Inject private EventHub	eventHub
	@Inject private Pulsar		pulsar
					Key:Bool	keys		:= Key:Bool[:]
					Bool		editMode	:= false
					Str			editText	:= ""

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
		if (e.key.isShift)
			keys[Key.shift] = true
		else
			keys.remove(Key.shift)
		
		if (editMode) {
			if (e.key.primary == Key.backspace || e.key.primary == Key.delete)
				editText = editText[0..<-1]
			else {
				// limit chars to those basic ASCII chars in the font
				if (e.keyChar != null && e.keyChar >= ' ' && e.keyChar < ' ' + (8 * 12)) {
					editText += e.keyChar.toChar
				}
			}
		}
	}

	private Void keyUp(Event e) {
		keys.remove(e.key.primary)
	}

	override Void onPaint(Graphics graphics) {
		g := gfx(graphics) 
		if (pulsar.isRunning)
			eventHub.fireEvent(DemoEvents#onDraw, [g])
	}
	
	Gfx gfx(Graphics graphics) {
		Gfx(graphics) {
			it.font8x8		= this.font8x8
			it.font16x16	= this.font16x16
		}
	}
}
