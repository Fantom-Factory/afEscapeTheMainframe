using gfx
using fwt
using afIoc

@Js
class BgGlow {

	static const Int	bgR				:= 0x00
	static const Int	bgG				:= 0x08
	static const Int	bgB				:= 0x1A
//	static const Int	bgHighlightR	:= 0x33
//	static const Int	bgHighlightG	:= 0x66
//	static const Int	bgHighlightB	:= 0x99
	static const Int	bgHighlightR	:= 0x00
	static const Int	bgHighlightG	:= 0xA0
	static const Int	bgHighlightB	:= 0xA0
	
	private 	Float	bgIndex			:= 0.5f
	private 	Float	bgHexX			:=   0f
	private 	Int		blink			:=   0

	private 	Image?	gameBg

	@Inject	private |->App|		app
	@Inject	private FannyImages	images
	
	new make(|This| f) {
		f(this)
		
	}
	
	Void draw(Gfx g2d, Int catchUp, Int? level := null) {
		if (gameBg == null) {
			gameBg = Image.makePainted(Size(768, 88)) |Graphics g| {
				gfx := Gfx(g)
				
				gfx.clear(Models.brand_darkBlue)
				
				gfx.brush = Models.brand_lightBlue
				midY := 144
				gfx.drawLine(0, midY +  56 - 200, gfx.bounds.w, midY +  56 - 200)
				gfx.drawLine(0, midY +  65 - 200, gfx.bounds.w, midY +  65 - 200)
				gfx.drawLine(0, midY +  77 - 200, gfx.bounds.w, midY +  77 - 200)
				gfx.drawLine(0, midY +  92 - 200, gfx.bounds.w, midY +  92 - 200)
				gfx.drawLine(0, midY + 112 - 200, gfx.bounds.w, midY + 112 - 200)
				gfx.drawLine(0, midY + 142 - 200, gfx.bounds.w, midY + 142 - 200)
			}
		}
		
		
		bgIndex += (0.0015f * catchUp)
		if (level != null)
			bgIndex += ((level - 1) * 0.0005f * catchUp)
		if (bgIndex > 1f)
			bgIndex -= 1f

		mul := (Sin.cos(bgIndex) + 1f) / 2f
		cR	:= ((bgHighlightR - bgR) * mul).toInt + bgR
		cG	:= ((bgHighlightG - bgG) * mul).toInt + bgG
		cB	:= ((bgHighlightB - bgB) * mul).toInt + bgB

		if (level == null) {
			g2d.brush = Color.makeArgb(0xFF, cR, cG, cB)
			g2d.fillRect(0, 0, g2d.bounds.w, g2d.bounds.h)
			
			w := 768
			h := 288
			x := -bgHexX.toInt
			g2d.g.copyImage(images.bgCircuit, Rect(x, 0, w-x, h), Rect(0, 0, w-x, h))
			g2d.g.copyImage(images.bgCircuit, Rect(0, 0, x, h), Rect(w-x, 0, x, h))

		} else {
			g2d.brush = Color.makeArgb(0xFF, cR, cG, cB)
			g2d.fillRect(0, 0, g2d.bounds.w, 200)

			w := 768
			h := 200
			x := -bgHexX.toInt
			g2d.g.copyImage(images.bgCircuit, Rect(x, 0, w-x, h), Rect(0, 0, w-x, h))
			g2d.g.copyImage(images.bgCircuit, Rect(0, 0, x, h), Rect(w-x, 0, x, h))
			
			g2d.drawImage(gameBg, 0, 200)			
		}

		// don't flash during games - it's off-putting!
		if (level == null && app().offline) {
			blink++
			if (blink > 80)
				blink = 0
			if (blink > 40) {
				g2d.drawFont8("Hi-Scores", g2d.bounds.w - ("hi-scores".size * 8) - 2, 270)
				g2d.drawFont8(" Offline ", g2d.bounds.w - (" offline ".size * 8) - 2, 278)
			}
		}
		
		if (level != null) {
			bgHexX -= level / 3f
			if (bgHexX < -768f)
				bgHexX += 768f
		}
	}
}
