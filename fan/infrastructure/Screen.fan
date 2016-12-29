using fwt
using gfx
using afIoc

@Js
class Screen : Canvas {

	@Inject private EventHub	eventHub
	@Inject private Pulsar		pulsar
	@Inject private FannyImages	images
					TouchMap	touch		:= TouchMap()
					KeyMap		keys		:= KeyMap()
					Bool		editMode	:= false
					Str			editText	:= ""
					Point?		mousePos {
						get { pos := &mousePos; &mousePos = null; return pos }
					}
					Int:Bool	mouseButtons:= Int:Bool[:]
					Int			mouseSensitivity := 3
					|->|?		mouseDownFunc
					Int			catchUp

	new make(|This| in) {
		in(this)
		this.doubleBuffered = true
		
		onKeyDown	.add { this.keyDown  (it) }
		onKeyUp		.add { this.keyUp	 (it) }
		onMouseMove	.add { this.mouseMove(it) }
		onMouseDown	.add { this.mouseDown(it) }
		onMouseUp	.add { this.mouseUp  (it) }
	}
	
	Void reset() {
		touch.reset
		keys.clear
		mouseButtons.clear
		editText = ""
	}
	
	private Void keyDown(Event e) {
		keys[e.key.primary] = true
		
		if (editMode) {
			if (e.key.primary == Key.backspace || e.key.primary == Key.delete) {
				if (editText.size > 0)
					editText = editText[0..<-1]
			}
			
			else {
				// TODO JS Bug - e.keyChar doesn't exist so we do it manually 
				e.keyChar = keyToChar(e.key)
				
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

	private Void mouseMove(Event e) {
		if (e.pos != null) {
			oldMousePos := &mousePos
			mousePos := mousePos = e.pos
			if (mouseButtons[1] == true && mousePos != null && oldMousePos != null) {
				dx := (mousePos.x - oldMousePos.x) / mouseSensitivity
				dy := (mousePos.y - oldMousePos.y) / mouseSensitivity
				
				if (dx < 0)	touch[Key.left ] = true
				if (dx > 0)	touch[Key.right] = true
				if (dy < 0)	touch[Key.up   ] = true
				if (dy > 0)	touch[Key.down ] = true
			}
		}
	}

	private Void mouseDown(Event e) {
		if (e.pos != null)
			mousePos = e.pos
		mouseButtons[e.button] = true
		mouseDownFunc?.call()
	}

	private Void mouseUp(Event e) {
		if (e.pos != null)
			mousePos = e.pos
		mouseButtons.remove(e.button)

		if (e.button == 1)
			touch.reset
	}

	override Void onPaint(Graphics graphics) {
		g2d := gfx(graphics) 

		if (!Runtime.isJs) {
			if (g2d.bounds.size != FannyTheFantom.windowSize) {				
				windowSize := Size(window.size.w - g2d.bounds.w + FannyTheFantom.windowSize.w, window.size.h - g2d.bounds.h + FannyTheFantom.windowSize.h)
				window.size = windowSize
			}
		}
		
		if (pulsar.isRunning) {
			eventHub.fireEvent(DemoEvents#onDraw, [g2d, catchUp])
			catchUp = 0
		}
	}
	
	Gfx gfx(Graphics graphics) {
		Gfx(graphics) {
			it.font8x8		= images.font8x8
			it.font16x16	= images.font16x16
		}
	}
	
	** Default to a British keyboard!
	private Int? keyToChar(Key key) {
		str := key.primary.toStr
		if (str.size == 1) {
			chr := str.chars.first
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
			case Key.space:
				return ' '
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
}

@Js
class KeyMap {
	private Key:Bool	keys	:= Key:Bool[:]
	
	Bool pressed(Key key) {
		keys.remove(key) != null
	}
	
	Bool down(Key key) {
		keys[key] == true
	}

	@Operator
	private Obj? get(Key key) { null }
//	Bool? get(Key key) { keys[key] }

	@Operator
	Void set(Key key, Bool val) {
		keys[key] = val
	}
	
	Void remove(Key key) {
		keys.remove(key)
	}
	
	Void clear() {
		keys.clear
	}
	
	Int size() {
		keys.size
	}
	
	KeyMap dup() {
		KeyMap { it.keys = this.keys.dup }
	}
}

@Js
class TouchMap {
	private Key:Bool	keys	:= Key:Bool[:]
	private Bool		hasSwiped
	
	Bool swiped(Key key) {
		val := keys[key]
		if (val == true)
			keys[key] = false
		return val == true
	}
	
	Bool moving(Key key) {
		keys[key] == true
	}

	@Operator
	private Obj? get(Key key) { null }
//	Bool? get(Key key) { keys[key] }

	@Operator
	Void set(Key key, Bool val) {
		if (keys[key] == null) {
			keys[key] = val
			hasSwiped = true
			// enable the user to keep swiping left / right / left / right / etc...
			if (key == Key.up)		keys.remove(Key.down)
			if (key == Key.down)	keys.remove(Key.up)
			if (key == Key.left)	keys.remove(Key.right)
			if (key == Key.right)	keys.remove(Key.left)
		}
	}
	
	Void reset() {
		keys.clear
		if (!hasSwiped)
			keys[Key.enter] = true
		hasSwiped = false
	}
	
	Void clear() {
		keys.clear
		hasSwiped = true
	}
}