using gfx::Color
using gfx::Brush

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
	
	virtual This draw(Gfx3d g3d) {
		drawFunc.call(this, g3d)
		return this
	}

	virtual This anim() {
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
		pts := points.map { pts3d[it] }
		g3d.drawPolyline(pts)
	}
}

const class Poly : Drawable {
	const	Int[]	points
	
	new makeWithPoints(Int[] points) {
		this.points = points
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		if (!isHidden(pts3d)) {
			pts := points.map { pts3d[it] }
			g3d.drawPolygon(pts)
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
