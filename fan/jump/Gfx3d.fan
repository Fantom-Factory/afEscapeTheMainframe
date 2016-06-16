using gfx::Color
using gfx::Point
using gfx::Brush
using util

class Gfx3d {
	Gfx g2d

	private Point3d	cameraPos	:= Point3d(0f, 0f, -1f)
	private Point3d	targetPos	:= Point3d(0f, 0f,  0f)
	private	Float	ax
	private	Float	ay
	private	Float	az

			Color?	fill
			Color?	edge

	new make(Gfx g2d) {
		this.g2d = g2d
	}


	This lookAt(Point3d cameraPos, Point3d targetPos := Point3d.defVal, Point3d cameraAngles := Point3d.defVal) {
		this.cameraPos	= cameraPos
		this.targetPos	= targetPos

		dx	:= targetPos.x - cameraPos.x
		dy	:= targetPos.y - cameraPos.y
		dz	:= targetPos.z - cameraPos.z
		
		this.ax	= -(dy / dz).atan * (0.5f / Float.pi)
		this.ay	= (dx / dz).atan * (0.5f / Float.pi)
		this.az	= 0f

		this.ax += cameraAngles.x
		this.ay += cameraAngles.y
		this.az += cameraAngles.z
		
		return this
	}

	Point3d[] drawModel(Model model) {		
		pts3d := (Point3d[]) model.points.map {
			it	.rotate(model.ax, model.ay, model.az)
				.translate(model.x, model.y, model.z)
				.translate(-cameraPos.x, -cameraPos.y, -cameraPos.z)
				.rotate(this.ax, this.ay, this.az)
				.project(300f)
		}

		model.drawables.each { it.draw(this, pts3d) }
		return pts3d
	}
	
	This drawPolyline(Point3d[] points) {
		ox := g2d.ox
		oy := g2d.oy
		g2d.g.brush = edge
		g2d.g.drawPolyline(points.map |pt| { Point(ox + pt.x.toInt, oy - pt.y.toInt) })
		return this
	}
	
	This drawPolygon(Point3d[] points) {
		ox	:= g2d.ox
		oy	:= g2d.oy
		pts := points.map |pt| { Point(ox + pt.x.toInt, oy - pt.y.toInt) }
		
		if (fill != null) {
			g2d.g.brush = fill
			g2d.g.fillPolygon(pts)
		}

		if (edge != null) {
			g2d.g.brush = edge
			g2d.g.drawPolygon(pts)
		}
		return this
	}

	This drawFont8(Str text, Point3d pt) {
		g2d.drawFont(text, g2d.ox+pt.x.toInt, g2d.oy- pt.y.toInt, g2d.font8x8, 8)
		return this
	}
}
