using gfx

class TitleBg {

	private	const Image	bgHex	:= Image(`fan://afDemo/res/bgHex-x288.png`)
	private const Int	bgColR	:= 0x22
	private const Int	bgColG	:= 0x44
	private const Int	bgColB	:= 0x66
	
	private	const Image	imgFanny	:= Image(`fan://afDemo/res/logo-fanny.png`)
	private	const Image	imgThe		:= Image(`fan://afDemo/res/logo-the.png`)
	private	const Image	imgFantom	:= Image(`fan://afDemo/res/logo-fantom.png`)

	private Twean?	tweanFanny
	private Twean?	tweanThe
	private Twean?	tweanFantom
	
	private Float 	bgHexX
	private Float	bgIndex		:= 0.5f
	private Int		time

	new make() {
		initTweans
	}
	
	Void draw(Gfx g2d) {
		bgIndex += 0.001f
		if (bgIndex > 1f)
			bgIndex -= 1f
		
		mul := (Sin.cos(bgIndex) + 1f) / 2f
		cR	:= (bgColR * mul).toInt
		cG	:= (bgColG * mul).toInt
		cB	:= (bgColB * mul).toInt
		
		g2d.clear(Color.makeArgb(0xFF, cR, cG, cB))
		
		g2d.drawImage(bgHex, 0, 0)
		
		tweanFanny	.draw(g2d, time)
		tweanThe	.draw(g2d, time)
		tweanFantom	.draw(g2d, time)

		if (time > 90)
			g2d.drawFont8("v${typeof.pod.version}", 690, 190)
		
		time++
	}
	
	Void initTweans() {
		tweanFanny = Twean {
			it.img			= imgFanny
			it.imgWidth		=  409
			it.imgHeight	=  198
			it.startFrame	=   50
			it.endFrame		=   65
			it.startX		= -409
			it.startY		=  -35
			it.finalX		=  255
			it.finalY		=  -35
		}
	
		tweanThe = Twean {
			it.img			= imgThe
			it.imgWidth		=  195
			it.imgHeight	=  169
			it.startFrame	=   60
			it.endFrame		=   70
			it.startX		=  410
			it.startY		=  288
			it.finalX		=  410
			it.finalY		=   25
		}
	
		tweanFantom	= Twean {
			it.img			= imgFantom
			it.imgWidth		=  452
			it.imgHeight	=  197
			it.startFrame	=   65
			it.endFrame		=   80
			it.startX		=  768
			it.startY		=   60
			it.finalX		=  360
			it.finalY		=   60
		}
	}
}


class Twean {
	Image	img
	Int		startFrame
	Int		endFrame
	Int		imgWidth
	Int		imgHeight
	Int		startX
	Int		startY
	Int		finalX
	Int		finalY
	
	new make(|This| f) { f(this) }

	Void draw(Gfx g2d, Int time) {
		if (time <= startFrame)
			return
		
		if (time > startFrame && time < endFrame) {
			frame := time - startFrame
			
			x := ((finalX - startX) * frame / (endFrame - startFrame)) + startX
			y := ((finalY - startY) * frame / (endFrame - startFrame)) + startY
			g2d.drawImage(img, x, y)
			return
		}
		
		g2d.drawImage(img, finalX, finalY)
	}
}