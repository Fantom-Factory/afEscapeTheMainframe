using gfx::Color
using gfx::Point

@Js
const mixin Drawable {
	abstract Void draw(Gfx3d g3d, Point3d[] pts3d)
}

@Js
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

@Js
const class Poly : Drawable {
	const	Int[]	points
	
	new makeWithPoints(Int[] points) {
		this.points = points
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		if (g3d.drawAllPolygons || !isHidden(pts3d)) {
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

@Js
const class Edge : Drawable {
	const	Color?	colour
	
	new makeWithColour(Color? colour) {
		this.colour = colour
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		g3d.edge = colour
	}
}

@Js
const class Fill : Drawable {
	const	Color?	colour
	
	new makeWithColour(Color? colour) {
		this.colour = colour
	}
	
	override Void draw(Gfx3d g3d, Point3d[] pts3d) {
		g3d.fill = colour
	}
}
