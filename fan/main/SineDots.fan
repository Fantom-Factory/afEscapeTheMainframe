using fwt
using gfx
using afIoc
using [java] fan.fwt::Fwt

using [java] javax.imageio::ImageIO
using [java] java.awt.image::BufferedImage
using [java] fanx.interop::Interop

class SineDots {

	@Inject Scope scope
	
	Dot[] dots	:= Dot[,]
	
	new make(|This| in) {
		in(this)		
		
		imgUrl	:= `res/Fanny.png`
		imgBuffer := loadImg(imgUrl.toFile, 50, 50)
		imgW := imgBuffer.getWidth
		imgH := imgBuffer.getHeight
				
		imgW.times |x| {
			imgH.times |y| {
				pix := Color("#" + imgBuffer.getRGB(x, y).and(0xffff_ffff).toHex(8))
				xx := x - imgW / 2
				yy := y - imgH / 2
				dot := (scope.build(Dot#) as Dot) {
					it.x = (xx*3) - yy	// forced perspective
					it.x = (xx*3)
					it.y = yy*3
					it.ax = ((xx*3) - (yy * 2f)).toInt
					it.ay = ((xx*3) - (yy * 2f)).toInt
					
//					it.ax = ((xx*7) - (yy * 0f)).toInt
//					it.ay = ((xx*7) - (yy * 0f)).toInt
//					it.ay = ((xx*1) - (yy * 6f)).toInt
					
					it.sx = 10
					it.sy = 10
					
					it.col = pix
				}
				dots.add(dot)
			}
		}
	}
	
	BufferedImage loadImg(File imgFile, Int w, Int h) {
		// http://stackoverflow.com/a/9417836/1532548
		imgBuffer := ImageIO.read(Interop.toJava(imgFile))
		tmpBuffer := imgBuffer.getScaledInstance(w, h, 4)	// 4 = java.awt::Image.SCALE_SMOOTH
		newBuffer := BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB)

		g2d := newBuffer.createGraphics
		g2d.drawImage(tmpBuffer, 0, 0, null)
		g2d.dispose
		
		if (newBuffer.getWidth < 0 || newBuffer.getHeight < 0)
			throw Err("Image not ready")

		return newBuffer
	}

	Void draw(Gfx g) {
//		g.brush = Color.white
		dots.each { it.draw(g).animate }
	}
}

class Dot {
	@Inject private Sin sin
	
	Int x
	Int y
	Int ax
	Int ay
	Int sx
	Int sy
	Color?	col
	
	new make(|This| in) { in(this) }

	This animate() {
		ax -= sx
		if (ax <   0) ax += 360
		if (ax > 360) ax -= 360
		ay -= sy
		if (ay <   0) ay += 360
		if (ay > 360) ay -= 360
		return this
	}
	
	This draw(Gfx g) {
		xx := x + sin.sin(30, ax)
		yy := y + sin.sin(30, ay)
		g.brush = col
//		g.drawPoint(xx + (g.bounds.w/2), yy+(g.bounds.h/2))
		g.drawRect(xx + (g.bounds.w/2), yy+(g.bounds.h/2), 1, 1)
		return this
	}
}