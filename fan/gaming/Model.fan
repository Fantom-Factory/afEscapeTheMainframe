using gfx::Color
using gfx::Brush
using gfx::Rect
using gfx::Point

@Js
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
