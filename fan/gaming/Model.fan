using gfx::Color
using gfx::Brush
using gfx::Rect
using gfx::Point

class Model {
	Point3d[]		points
	Drawable[]		drawables
	|Model|?		animFunc
	|Model, Gfx3d| 	drawFunc := |Model model, Gfx3d g3d| {
		g3d.drawModel(model)
	}

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
	
	Float xMin() {
		xs := (Float[]) points.map { it.x } 
		return xs.min + this.x
	}
	
	Float xMax() {
		xs := (Float[]) points.map { it.x } 
		return xs.max + this.x
	}
	
	Float yMin() {
		ys := (Float[]) points.map { it.y } 
		return ys.min + this.y
	}
	
	Float yMax() {
		ys := (Float[]) points.map { it.y } 
		return ys.max + this.y
	}
	
	Float zMin() {
		zs := (Float[]) points.map { it.z } 
		return zs.min + this.z
	}
	
	Float zMax() {
		zs := (Float[]) points.map { it.z } 
		return zs.max + this.z
	}
	
	Rect collisionRect() {
		xMin := (Float) points.map { it.x }.min - 5f
		xMax := (Float) points.map { it.x }.max + 5f
		yMin := (Float) points.map { it.y }.min - 5f
		yMax := (Float) points.map { it.y }.max + 5f
		w	 := xMax - xMin
		h	 := yMax - yMin
		
		return Rect((xMin + x).toInt, (yMin + y).toInt, w.toInt, h.toInt)
	}

	virtual Void draw(Gfx3d g3d) {
		drawFunc.call(this, g3d)
		return this
	}

	virtual Void anim() {
		animFunc?.call(this)
		return this
	}	
}

const mixin Drawable {
	abstract Void draw(Gfx3d g3d, Point3d[] pts3d)
}

const class Line : Drawable {
	const	Int[]	points
	
	new makeWithPoints(Int[] points) {
		this.points = points
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		g2d	  := g3d.g2d
		pts	  := (Point3d[]) points.map { pts3d[it] }
		pts2d := pts.map |pt| { Point(g2d.ox + pt.x.toInt, g2d.oy - pt.y.toInt) }
		
		g2d.g.brush = g3d.edge
		g2d.g.drawPolyline(pts2d)
	}
}

const class Poly : Drawable {
	const	Int[]	points
	
	new makeWithPoints(Int[] points) {
		this.points = points
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		if (!isHidden(pts3d)) {
			g2d   := g3d.g2d
			pts   := (Point3d[]) points.map { pts3d[it] }
			pts2d := pts.map |pt| { Point(g2d.ox + pt.x.toInt, g2d.oy - pt.y.toInt) }
			
			if (g3d.fill != null) {
				g2d.g.brush = g3d.fill
				g2d.g.fillPolygon(pts2d)
			}
	
			if (g3d.edge != null) {
				g2d.g.brush = g3d.edge
				g2d.g.drawPolygon(pts2d)
			}
		}
	}
	
	Bool isHidden(Point3d[] pts3d) {
		norm := Point3d.normal(pts3d[points[0]], pts3d[points[1]], pts3d[points[2]])
		return norm.z > 0f
	}
}

const class Edge : Drawable {
	const	Color?	colour
	
	new makeWithColour(Color? colour) {
		this.colour = colour
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		g3d.edge = colour
	}
}

const class Fill : Drawable {
	const	Color?	colour
	
	new makeWithColour(Color? colour) {
		this.colour = colour
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		g3d.fill = colour
	}
}
