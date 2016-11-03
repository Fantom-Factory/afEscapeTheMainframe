using gfx

class TitleBg {

	private	const Image	imgFanny	:= Image(`fan://afFannyTheFantom/res/logo-fanny.png`)
	private	const Image	imgThe		:= Image(`fan://afFannyTheFantom/res/logo-the.png`)
	private	const Image	imgFantom	:= Image(`fan://afFannyTheFantom/res/logo-fantom.png`)
	private	const Image	theFanny	:= Image(`fan://afFannyTheFantom/res/fanny-x180.png`)

	private Twean?	tweanFanny
	private Twean?	tweanThe
	private Twean?	tweanFantom
	private Twean?	tweanTheFanny
	
	private Float 	fannyY
			Int		time	:= 50

	new make() {
		initTweans
	}

	Void draw(Gfx g2d) {
		tweanFanny	.draw(g2d, time)
		tweanThe	.draw(g2d, time)
		tweanFantom	.draw(g2d, time)
		tweanTheFanny.draw(g2d, time)

		if (time > 110)
			g2d.drawFont8("v${typeof.pod.version}", 690, 190)
		
		y := (Sin.sin(fannyY) * 15f).toInt + (288 - 180) / 2
		tweanTheFanny.startY = y.toInt
		tweanTheFanny.finalY = y.toInt
		fannyY += 0.007f
		if (fannyY > 1f)
			fannyY -= 1f
		
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
	
		tweanTheFanny	= Twean {
			it.img			= theFanny
			it.imgWidth		=  180
			it.imgHeight	=  180
			it.startFrame	=   80
			it.endFrame		=   95
			it.startX		= -180
			it.startY		=    0
			it.finalX		=   30
			it.finalY		=    0
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
			
			ratio := frame.toFloat / (endFrame - startFrame)
			sinio := Sin.sin(ratio * 0.25f)
			
			x := ((finalX - startX) * sinio) + startX
			y := ((finalY - startY) * sinio) + startY
			g2d.drawImage(img, x.toInt, y.toInt)
			return
		}
		
		g2d.drawImage(img, finalX, finalY)
	}
}