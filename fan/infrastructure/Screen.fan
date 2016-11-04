using fwt
using gfx
using afIoc

@Js
class Screen : Canvas {

	@Inject private EventHub	eventHub
	@Inject private Pulsar		pulsar
	@Inject private FannyImages	images
					Key:Bool	keys		:= Key:Bool[:]
					Bool		editMode	:= false
					Str			editText	:= ""

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
				// TODO JS Bug - e.keyChar doesn't exist so we do it manually 
				e.keyChar = keyToChar(e.key)
				
				// limit chars to those basic ASCII chars in the font
				if (e.keyChar != null && e.keyChar >= ' ' && e.keyChar < ' ' + (8 * 12)) {
					editText += e.keyChar.toChar
				}
			}
			
			if (editText.size > HiScores.maxNameSize)
				editText = editText[1..-1]
		}
	}

	** Default to a British keyboard!
	private Int? keyToChar(Key key) {
		str := key.primary.toStr
		if (str.size == 1) {
			chr := str.chars.first
			if (chr == ' ')
				return chr
			if (chr.isAlpha)
				return key.isShift ? chr.upper : chr.lower
			if (chr.isDigit) {
				if (key.isShift) {
					return "!\"£\$%^&*()".chars.get(chr - '1')
				} else
					return chr
			}
			if (chr == '-')
				return key.isShift ? '-' : '_'
			if (chr == '=')
				return key.isShift ? '+' : '='
		}
		
		switch (key.primary) {
			case Key.comma:
				return key.isShift ? '<' : ','
			case Key.period:
				return key.isShift ? '>' : '.' 
			case Key.slash:
				return key.isShift ? '?' : '/' 
			case Key.semicolon:
				return key.isShift ? ':' : ';'
			case Key.quote:
				return key.isShift ? '@' : '\'' 
			case Key.openBracket:
				return key.isShift ? '{': '['
			case Key.closeBracket:
				return key.isShift ? '}' : ']'
			case Key.backSlash:
				return key.isShift ? '|' : '\\'
			case Key.backtick:
				return key.isShift ? '¬' : '`'
		}
		
		return null
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
			it.font8x8		= images.font8x8
			it.font16x16	= images.font16x16
		}
	}
}
