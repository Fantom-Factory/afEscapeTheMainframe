using gfx::Color

class Model {
		Point3d[]	points
	const Int[][]	lines
			Color	colour	:= Color.white
	
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
			it.lines	= this.lines
			it.colour	= this.colour
			it.ax		= this.ax
			it.ay		= this.ay
			it.az		= this.az
		}
	}
	
	Void draw(Gfx3d gfx) {
		gfx.brush = colour
		gfx.drawModel(this)
	}
}
