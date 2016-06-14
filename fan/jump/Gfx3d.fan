using gfx::Brush
using util

class Gfx3d {
	Gfx gfx

	private Point3d	cameraPos	:= Point3d(0f, 0f, -1f)
	private Point3d	targetPos	:= Point3d(0f, 0f,  0f)
	private	Float	dx
	private	Float	dy
	private	Float	dz
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

	This lookAt(Point3d cameraPos, Point3d targetPos, Obj? upVector_todo := null) {
		this.cameraPos	= cameraPos
		this.targetPos	= targetPos

		this.dx			= targetPos.x - cameraPos.x
		this.dy			= targetPos.y - cameraPos.y
		this.dz			= targetPos.z - cameraPos.z
		
		this.ax			= (dy / dz).atan / (Float.pi / 2)
		this.ay			= (dx / dz).atan / (Float.pi / 2)
		this.az			= (dy / dx).atan / (Float.pi / 2)
		
		return this
	}

	Void drawModel(Model model) {
		
		points := (Point2d[]) model.points.map {
			it	.rotate(model.ax+ax, model.ay+ay, model.az+az)
				.translate(model.x+dx, model.y+dy, model.z+dz)
//				.rotate(ax, ay, az)
//				.translate(dx, dy, dz)
				.applyPerspective(300f)
				.scale(0.5f)
		}
		
		model.lines.each |lines| {
			li := -1
			lines.each |i| {
				p2 := points[i]
				
				if (li != -1) {
					p1 := points[li]
					gfx.drawLine(p1.x.toInt, p1.y.toInt, p2.x.toInt, p2.y.toInt)
				}
				
				li = i
			}
		}
	}
}
