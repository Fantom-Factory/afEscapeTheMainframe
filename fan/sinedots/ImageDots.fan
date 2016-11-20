using [java] javax.imageio::ImageIO
using [java] java.awt.image::BufferedImage
using [java] fanx.interop::Interop

class ImageDots {
	
	static Void main(Str[] args) {
		imgUrl	:= `res/images/fanny-x180.png`
		imgBuf	:= loadImg(imgUrl.toFile, 40, 40)
		imgW	:= imgBuf.getWidth
		imgH	:= imgBuf.getHeight
		buf		:= Buf()
		
		imgW.times |x| {
			imgH.times |y| {
				buf.out.writeI4(imgBuf.getRGB(x, y))
			}
		}
		
		echo("imgHex := \"${buf.flip.toHex}\"")
	}

	private static BufferedImage loadImg(File imgFile, Int w, Int h) {
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
	
}
