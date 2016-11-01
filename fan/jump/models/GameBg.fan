using gfx
using fwt

const class GameBg {

	private	const Image	bgHex	:= Image(`fan://afDemo/res/bgHex-x200.png`)
	private const Int	bgColR	:= 0x33
	private const Int	bgColG	:= 0x66
	private const Int	bgColB	:= 0x99

	Void draw(Gfx g2d, GameData data) {
		data.bgIndex += 0.000f + (data.level * 0.001f)
		if (data.bgIndex > 1f)
			data.bgIndex -= 1f
		
		mul := (Sin.cos(data.bgIndex) + 1f) / 2f
		cR	:= (bgColR * mul).toInt
		cG	:= (bgColG * mul).toInt
		cB	:= (bgColB * mul).toInt
		
		g2d.clear(Color.makeArgb(0xFF, cR, cG, cB))
		
		g2d.drawImage(bgHex, data.bgHexX.toInt, 0)
		data.bgHexX -= data.level / 3f
		if (data.bgHexX < -111f)
			data.bgHexX += 111f
	}
}
