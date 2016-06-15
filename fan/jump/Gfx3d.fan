using gfx::Brush
using util

class Gfx3d {
	Gfx gfx

	private Point3d	cameraPos	:= Point3d(0f, 0f, -1f)
	private Point3d	targetPos	:= Point3d(0f, 0f,  0f)
	private	Float	ax
	private	Float	ay
	private	Float	az

	new make(Gfx gfx) {
		this.gfx = gfx
	}

	Brush brush {
		get { gfx.brush }
		set { gfx.brush = it }
	}

	This lookAt(Point3d cameraPos, Point3d targetPos := Point3d.defVal, Point3d cameraAngles := Point3d.defVal) {
		this.cameraPos	= cameraPos
		this.targetPos	= targetPos

		dx	:= targetPos.x - cameraPos.x
		dy	:= targetPos.y - cameraPos.y
		dz	:= targetPos.z - cameraPos.z
		
		this.ax	= -(dy / dz).atan * (0.5f / Float.pi)
		this.ay	= -(dx / dz).atan * (0.5f / Float.pi)
		this.az	= 0f

		this.ax += cameraAngles.x
		this.ay += cameraAngles.y
		this.az += cameraAngles.z
		
		return this
	}

	Void drawModel(Model model) {		
		points := (Point2d[]) model.points.map {
			it	.rotate(model.ax, model.ay, model.az)
				.translate(model.x, model.y, model.z)
				.translate(cameraPos.x, cameraPos.y, cameraPos.z)
				.rotate(this.ax, this.ay, this.az)
				.applyPerspective(300f)
		}
		
		model.drawables.each { it.draw(this, points) }
	}
	
	This drawPolyline(Point2d[] points) {
		gfx.drawPolyline(points)
		return this
	}
	
	This drawPolygon(Point2d[] points) {
		gfx.drawPolygon(points)
		return this
	}

}
