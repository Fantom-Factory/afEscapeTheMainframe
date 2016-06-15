using gfx::Color
using gfx::Brush

class Model {
			Point3d[]	points
	const	Drawable[]	drawables
			Color		colour	:= Color.white
	
			Float	x
			Float	y
			Float	z
		
			Float	ax
			Float	ay
			Float	az
	
	new make(|This| in) { in(this) }
	
	This rotate(Float ax, Float ay, Float az) {
		points = points.map { it.rotate(ax, ay, az) }
		return this
	}
	
	This scale(Float sx, Float sy := sx, Float sz := sx) {
		points = points.map { it.scale(sx, sy, sz) }
		return this
	}
	
	This translate(Float dx, Float dy, Float dz) {
		points = points.map { it.translate(dx, dy, dz) }
		return this
	}
	
	Model dup() {
		Model {
			it.points	= this.points.dup
			it.drawables= this.drawables
			it.colour	= this.colour
			it.ax		= this.ax
			it.ay		= this.ay
			it.az		= this.az
		}
	}
	
	Void draw(Gfx3d g3d) {
		g3d.brush = colour
		g3d.drawModel(this)
	}
}

const mixin Drawable {
	abstract Void draw(Gfx3d g3d, Point2d[] pts2d)
}

const class Line : Drawable {
	const	Int[]	points
	const	Brush?	colour
	
	new makeItBlock(|This| in) { in(this) }
	
	new makeWithPoints(Int[] points) {
		this.points = points
	}
	
	override Void draw(Gfx3d g3d, Point2d[] pts2d) {
		if (colour != null)
			g3d.brush = colour
		
		pts := points.map { pts2d[it] }
		g3d.drawPolyline(pts)
	}
}

const class Poly : Drawable {
	const	Int[]	points
	const	Brush?	fill
	
	new make(|This| in) { in(this) }

	override Void draw(Gfx3d g3d, Point2d[] pts2d) {
		if (fill != null)
			g3d.brush = fill
		
		pts := points.map { pts2d[it] }
		g3d.drawPolygon(pts)
	}
}
