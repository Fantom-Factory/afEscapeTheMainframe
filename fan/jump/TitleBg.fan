using gfx

@Js
class TitleBg {

	private FannyImages	images
	private Twean?	tweanFanny
	private Twean?	tweanThe
	private Twean?	tweanFantom
	private Twean?	tweanTheFanny
	
			Float 	fannyY
			Int		time	:= 50

	new make(FannyImages images) {
		this.images = images
		initTweans
	}

	Void draw(Gfx g2d) {
		tweanFanny	.draw(g2d, time)
		tweanThe	.draw(g2d, time)
		tweanFantom	.draw(g2d, time)
		tweanTheFanny.draw(g2d, time)

		if (time > 120) {
			noOfChars := ((time - 120) / 4).min("Escape the Mainframe".size)
			g2d.drawFont16("Escape the Mainframe"[0..<noOfChars], 424, 224)
		}

		if (time > 120 + ("Escape the Mainframe".size * 4) + 10)
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
			it.img			= images.logoFanny
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
			it.img			= images.logoThe
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
			it.img			= images.logoFantom
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
			it.img			= images.fanny_x180
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

@Js
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
	Bool	tweanIn	:= true
	Bool	endOffScreen
	
	new make(|This| f) { f(this) }

	virtual Void draw(Gfx g2d, Int time) {
		if (time <= startFrame)
			return
		
		if (time > startFrame && time < endFrame) {
			frame := time - startFrame
			
			ratio := frame.toFloat / (endFrame - startFrame)
			angle := ratio * 0.25f
			if (!tweanIn)
				angle += 0.25f
			sinio := Sin.sin(angle)
			if (!tweanIn)
				sinio = 1f - sinio
			
			x := ((finalX - startX) * sinio) + startX
			y := ((finalY - startY) * sinio) + startY
			g2d.drawImage(img, x.toInt, y.toInt)
			return
		}
		
		if (!endOffScreen)
			g2d.drawImage(img, finalX, finalY)
	}
}