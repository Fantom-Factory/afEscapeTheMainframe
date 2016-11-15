using gfx::Color
using gfx::Rect
using gfx::Point

@Js
class BonusExplo : Model {
	Bool				killMe
	BonusExploSquare[]	squares
	
	new make(|This| in) : super(in) { }
	
	override Void draw(Gfx3d g3d) {
		g2d := g3d.g2d
		squares.each { it.draw(g2d) }
	}
	
	override Void anim() {
		squares.each { it.anim }
		if (squares.first.size <= 0f)
			killMe = true
	}
}

@Js
class BonusExploSquare {
	Float		force	:= 10f
	Float		size	:= 0.21f
	Point2d[]	points	:= Point2d#.emptyList
	Point2d		movementVector

	Float	x
	Float	y
	Float	az
	Float	dx
	
	new make(|This| f) { f(this) }

	Void anim() {		
		thing := movementVector.scale(force)
		x += thing.x - dx
		y += thing.y

		force = 0f.max(force - 0.18f)
		
		az += 0.04f
				
		points = [
			Point2d(-100f,  100f),
			Point2d( 100f,  100f),
			Point2d( 100f, -100f),
			Point2d(-100f, -100f),
		]
		scale(size)
		size = 0f.max(size-0.007f)
	}
	
	Void draw(Gfx g2d) {
		if ((g2d.ox + x) < 0f)	return
		if ((g2d.oy + y) < 0f)	return

		pts2d := points
			.map |pt| { pt.rotate(az).translate(x, y) }
			.map |Point2d pt -> Point| { Point(g2d.ox + pt.x.toInt, g2d.oy - pt.y.toInt) }

		g2d.g.brush = Models.cube_fill
		g2d.g.fillPolygon(pts2d)

		g2d.g.brush = Models.cube_edge
		g2d.g.drawPolygon(pts2d)		
	}
	
	This scale(Float sx, Float sy := sx) {
		points = points.map { it.scale(sx, sy) }
		return this
	}
}
