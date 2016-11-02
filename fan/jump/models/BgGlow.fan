using gfx
using fwt
using afIoc

class BgGlow {

//	private	const Image	bgHex1	:= Image(`fan://afDemo/res/bgHex-x200.png`)
//	private	const Image	bgHex2	:= Image(`fan://afDemo/res/bgHex-x288.png`)
	private	const Image	bgHex1	:= Image(`fan://afDemo/res/bgHex-3.png`)
	private	const Image	bgHex2	:= Image(`fan://afDemo/res/bgHex-3.png`)
	private const Int	bgColR	:= 0x33
	private const Int	bgColG	:= 0x66
	private const Int	bgColB	:= 0x99
	
	private 	Float	bgIndex	:= 0.5f
	private 	Float	bgHexX	:=   0f
	private 	Int		blink	:=   0

	@Inject	private |->App|	app
	
	new make(|This| f) { f(this) }
	
	Void draw(Gfx g2d, Int? level := null) {
		bgIndex += 0.001f
		if (level != null)
			bgIndex += (level - 1) * 0.001f
		if (bgIndex > 1f)
			bgIndex -= 1f
		
		mul := (Sin.cos(bgIndex) + 1f) / 2f
		cR	:= (bgColR * mul).toInt
		cG	:= (bgColG * mul).toInt
		cB	:= (bgColB * mul).toInt
		
		g2d.clear(Color.makeArgb(0xFF, cR, cG, cB))
		
		img := level == null ? bgHex2 : bgHex1
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
