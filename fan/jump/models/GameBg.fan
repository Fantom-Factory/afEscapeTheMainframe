using gfx
using fwt

class GameBg {

	private	Image	bgHex	:= Image(`fan://afDemo/res/bgHex-2.png`)
	private	Image	bgBlob	:= Image(`fan://afDemo/res/bgBlob.png`)
	private Float 	bgHexX
	private Float	bgBlobX1	:= -100f
	private Float	bgBlobA1
	private Float	bgBlobX2	:= -100f
	private Float	bgBlobA2	:= 180f

	Void draw(Gfx g2d, GameData data) {
		g2d.clear
		
		bgBlobY1 := Sin.sin(bgBlobA1 / 360) * 50
		g2d.drawImage(bgBlob, bgBlobX1.toInt, bgBlobY1.toInt + 50)
		
		bgBlobX1 += 9
		if (bgBlobX1 > g2d.bounds.w.toFloat)
			bgBlobX1 = -100f
		bgBlobA1 += 2
		if (bgBlobA1 > 360f)
			bgBlobA1 = 0f
		
		bgBlobY2 := Sin.sin(bgBlobA2 / 360) * 50
		g2d.drawImage(bgBlob, bgBlobX2.toInt, bgBlobY2.toInt + 50)
		
		bgBlobX2 += 7f
		if (bgBlobX2 > g2d.bounds.w.toFloat)
			bgBlobX2 = -100f
		bgBlobA2 += 1f
		if (bgBlobA2 > 360f)
			bgBlobA2 = 0f
		
//		g2d.drawImage(bgHex, bgHexX.toInt, 0)
		g2d.drawImage(bgHex, 0, 0)
		bgHexX -= data.level / 3f
		if (bgHexX < -111f)
			bgHexX += 111f
	}	
	
}
