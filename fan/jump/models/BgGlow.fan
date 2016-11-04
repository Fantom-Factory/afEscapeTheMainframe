using gfx
using fwt
using afIoc

@Js
class BgGlow {

	static const Int	bgR				:= 0x00
	static const Int	bgG				:= 0x08
	static const Int	bgB				:= 0x1A
	static const Int	bgHighlightR	:= 0x33
	static const Int	bgHighlightG	:= 0x66
	static const Int	bgHighlightB	:= 0x99
	
	private 	Float	bgIndex			:= 0.5f
	private 	Float	bgHexX			:=   0f
	private 	Int		blink			:=   0

	@Inject	private |->App|		app
	@Inject	private FannyImages	images
	
	new make(|This| f) { f(this) }
	
	Void draw(Gfx g2d, Int? level := null) {
		bgIndex += 0.0015f
		if (level != null)
			bgIndex += (level - 1) * 0.0015f
		if (bgIndex > 1f)
			bgIndex -= 1f
		
		mul := (Sin.cos(bgIndex) + 1f) / 2f
		cR	:= ((bgHighlightR - bgR) * mul).toInt + bgR
		cG	:= ((bgHighlightG - bgG) * mul).toInt + bgG
		cB	:= ((bgHighlightB - bgB) * mul).toInt + bgB
		
		g2d.clear(Color.makeArgb(0xFF, cR, cG, cB))
		
		img := level == null ? images.bgHex_x288 : images.bgHex_x200
		g2d.drawImage(img, bgHexX.toInt, 0)

		
		blink++
		if (blink > 80)
			blink = 0
		if (app().offline && blink > 40) {
			g2d.drawFont8("Hi-Scores", g2d.bounds.w - ("hi-scores".size * 8) - 2, 270)
			g2d.drawFont8(" Offline ", g2d.bounds.w - (" offline ".size * 8) - 2, 278)
		}
		
		if (level != null) {
			bgHexX -= level / 3f
			if (bgHexX < -111f)
				bgHexX += 111f
		}
	}
}
