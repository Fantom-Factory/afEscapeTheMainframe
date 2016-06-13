using afIoc
using fwt
using gfx

** Wrapper around 'fwt::Graphics'.
class Gfx {
	
//	@Inject 
	private Image?		font8x8
//	@Inject 
	private Image?		font16x16
	
	private Graphics	g
	private Int 		ox
	private Int 		oy

	new make(Graphics g, |This|? f := null) {
		f?.call(this)
		this.g = g
	}
	
	Void offset(Int x, Int y) {
		ox += x
		oy += y
	}

	This offsetCentre() {
		ox = (bounds.w / 2) + bounds.x 
		oy = (bounds.h / 2) + bounds.y
		return this
	}
	
	Brush brush {
		get { g.brush }
		set { g.brush = it }
	}
	
	This clip(Rect bounds) {
		g.clip(bounds)
		return this
	}
	
	once Rect bounds() {
		g.clipBounds
	}

	This drawImage(Image image, Int x, Int y) {
		g.drawImage(image, ox+x, oy+y)
		return this
	}
	
	This copyImage(Image image, Rect src, Rect dest) {
		g.copyImage(image, src, Rect(ox+dest.x, oy+dest.y, dest.w, dest.h))
		return this
	}
	
	This drawRect(Int x, Int y, Int w, Int h) {
		g.drawRect(ox+x, oy+y, w, h)
		return this
	}
	
	This drawLine(Int x1, Int y1, Int x2, Int y2) {
		g.drawLine(ox+x1, oy+y1, ox+x2, oy+y2)
		return this
	}
	
	This fillRect(Int x, Int y, Int w, Int h) {
		g.fillRect(ox+x, oy+y, w, h)
		return this		
	}
	
	This drawPoint(Int x, Int y) {
		g.drawLine(ox+x, oy+y, ox+x, oy+y)
		return this		
	}
	
	This fillRoundRect(Int x, Int y, Int w, Int h, Int wArc, Int hArc) {
		g.fillRoundRect(ox+x, oy+y, w, h, wArc, hArc)
		return this
	}

	This drawFont8Centred(Str text, Int y) {
		x := (g.clipBounds.w - (text.size * 8)) / 2
		drawFont8(text, x, y)
		return this
	}

	This drawFont8(Str text, Int x, Int y) {
		drawFont(text, ox+x, oy+y, font8x8, 8)
		return this
	}

	This drawFont16Centred(Str text, Int y) {
		x := (g.clipBounds.w - (text.size * 16)) / 2
		drawFont16(text, x, y)
		return this
	}

	This drawFont16(Str text, Int x, Int y) {
		drawFont(text, ox+x, oy+y, font16x16, 16)
		return this
	}
	
	Void clear() {
		fill(Color.black)
	}

	Void fill(Color colour) {
		brush = colour
		fillRect(0, 0, g.clipBounds.w, g.clipBounds.h)
	}
	
	private Void drawFont(Str text, Int initX, Int initY, Image font, Int fontSize) {
		x := initX
		y := initY

		text.each |char| {   
			if (char == '\n') {
				x  = initX
				y += fontSize				
			} else {
				
				// work out how many chars along from [SPACE] our char is
				chrPos := char - ' '
	
				srcX := (chrPos % 8) * fontSize
				srcY := (chrPos / 8) * fontSize
	
				g.copyImage(font, Rect(srcX, srcY, fontSize, fontSize), Rect(x, y, fontSize, fontSize))
	
				x += fontSize
			}
		}
	}
}
