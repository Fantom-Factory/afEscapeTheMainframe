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
		
		imgUrl	:= `res/images/fanny-x180.png`
		imgBuffer := loadImg(imgUrl.toFile, 50, 50)
		imgW := imgBuffer.getWidth
		imgH := imgBuffer.getHeight
				
		imgW.times |x| {
			imgH.times |y| {
				pix := Color("#" + imgBuffer.getRGB(x, y).and(0xffff_ffff).toHex(8))
//				pix = Color.white
				xx := x - imgW / 2
				yy := y - imgH / 2
				dot := (scope.build(Dot#) as Dot) {

//					it.x  = (xx*3) - yy	// forced perspective
//					it.y  = (yy*3) - xx
//					it.v  = 30
//					it.ax = ((xx*9) - (yy * 2f)).toInt
//					it.ay = ((xx*3) - (yy * 2f)).toInt
//					it.av = 90
//					it.sx = 7
//					it.sy = 7
//					it.sv = 0
					
					it.x  = (xx*3) - yy
					it.y  = (yy*3) - xx
					it.v  = 30
					it.ax = ((xx*7) - (yy * 0f)).toInt + 90
					it.ay = ((xx*0) - (yy * 7f)).toInt + 90
					it.av = 0
					it.sx = 0
					it.sy = 0
					it.sv = 7
					
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
	Int x
	Int y
	Int v
	Int ax
	Int ay
	Int av
	Int sx
	Int sy
	Int sv
	Color?	col
	
	new make(|This| in) { in(this) }

	This animate() {
		ax -= sx
		if (ax <   0) ax += 360
		if (ax > 360) ax -= 360
		ay -= sy
		if (ay <   0) ay += 360
		if (ay > 360) ay -= 360
		av -= sv
		if (av <   0) av += 360
		if (av > 360) av -= 360
		return this
	}
	
	This draw(Gfx g) {
		sin := SinOld.instance
		vv := sin.sin(v, av)
		xx := x + sin.sin(vv, ax)
		yy := y + sin.sin(vv, ay)
		g.brush = col
//		g.drawPoint(xx + (g.bounds.w/2), yy+(g.bounds.h/2))
		g.drawRect(xx + (g.bounds.w/2), yy+(g.bounds.h/2), 1, 1)
		return this
	}
}