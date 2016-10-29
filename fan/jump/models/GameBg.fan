using gfx
using fwt

class GameBg {

	private	Image	bgHex	:= Image(`fan://afDemo/res/bgHex.png`)
	private	Image	bgBlob	:= Image(`fan://afDemo/res/bgBlob.png`)
	private Float 	bgHexX
	private Float	bgBlobX	:= -100f
	private Float	bgBlobA

	Void draw(Gfx g2d, GameData data) {
		g2d.clear
		
		bgBlobY := Sin.sin(bgBlobA / 360) * 50
		g2d.drawImage(bgBlob, bgBlobX.toInt, bgBlobY.toInt + 50)
		
		bgBlobX += 2
		if (bgBlobX > g2d.bounds.w.toFloat)
			bgBlobX = -100f
		bgBlobA += 2
		if (bgBlobA > 360f)
			bgBlobA = 0f
		
		g2d.drawImage(bgHex, bgHexX.toInt, 0)
		bgHexX -= data.level / 3f
		if (bgHexX < -111f)
			bgHexX += 111f
	}	
	
}
