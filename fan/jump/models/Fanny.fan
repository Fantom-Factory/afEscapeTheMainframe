using gfx::Rect

class Fanny : Model {
	GameData data
	Float	sy
	Bool	jumpHeld
	Bool	jumpEnabled	:= true
	Bool	squished

	Point3d[] normPoints := Point3d[
		// body
		Point3d(-15f,  40f, -25f),
		Point3d( 30f,  40f, -25f),
		Point3d( 30f, -40f, -35f),
		Point3d(-40f, -40f, -35f),
		Point3d(-15f,  40f,  25f),
		Point3d( 30f,  40f,  25f),
		Point3d( 30f, -40f,  35f),
		Point3d(-40f, -40f,  35f),
		
		// eyes
		Point3d( 30f,  30f, -15f),
		Point3d( 30f,  30f,  15f),
		Point3d( 30f,  10f,  15f),
		Point3d( 30f,  10f, -15f),
	]

	Point3d[] squishPoints := Point3d[
		// body
		Point3d(-25f, -15f, -35f),
		Point3d( 45f, -15f, -35f),
		Point3d( 45f, -40f, -45f),
		Point3d(-45f, -40f, -45f),
		Point3d(-25f, -15f,  35f),
		Point3d( 45f, -15f,  35f),
		Point3d( 45f, -40f,  45f),
		Point3d(-45f, -40f,  45f),
		
		// eyes
		Point3d( 45f, -15f, -15f),
		Point3d( 45f, -15f,  15f),
		Point3d( 45f, -35f,  15f),
		Point3d( 45f, -35f, -15f),
	]
	
	new make(GameData data, |This| in) : super(in) {
		this.data = data
		
		x = -420f
		y = -110f
		z = -70f
	}

	Void jump(Bool jump) {
		if (!jump) {
			jumpHeld = false

		} else
			if (jumpEnabled || jumpHeld) {
				sy += 15f
				sy = sy.min(15f)
				
				jumpEnabled = false
				jumpHeld = true
				
				if (y > 25f)
					jumpHeld = false			
			}
	}

	Void squish(Bool squish) {
		squished = squish
	}
	
	Void ghost(Bool ghost) {
		if (ghost) {
			drawables[0] = Fill(null) 
			drawables[1] = Edge(Models.fanny_silver)
		} else {
			drawables[0] = Fill(Models.fanny_silver) 
			drawables[1] = Edge(Models.brand_white)
		}
	}
	
	override This draw(Gfx3d g3d) {
		// don't draw fanny if we're dying - we draw the explo instead
		data.dying ? this : super.draw(g3d)
	}
	
	override This anim() {
		y += sy
		if (y <= -110f) {
			y = -110f
			sy = 0f
			jumpEnabled = true
		}

		normPoints := normPoints.dup
		[0, 1, 4, 5, 8, 9, 10, 11].each |i| {
			normPoints[i] = normPoints[i].translate(data.floorSpeed, 0f, 0f)
		}
		
		// if we're not touching the floor
		if (y > -110f) {
			dy	  := sy * 0.4f
			front := Int[0, 3, 4, 7]	// front
			back  := Int[1, 2, 5, 6]	// back
			pts	  := squished ? squishPoints : normPoints
			
			points = pts.map |pt, i| {
				if (front.contains(i)) {
					pt = pt.translate(0f, -dy, 0f)
				} else
				if (back.contains(i)) {
					pt = pt.translate(0f, dy, 0f)
				}
				return pt
			}
		} else
			points = squished ? squishPoints : normPoints

		
		// if we're not touching the floor
		if (y > -110f) {
			sy -= 1.5f
		}

		return this
	}
	
	Bool intersects(Block block) {
		f1 := Point2d(points[0].x + x, points[0].y + y)
		f2 := Point2d(points[1].x + x, points[1].y + y)
		f3 := Point2d(points[2].x + x, points[2].y + y)
		f4 := Point2d(points[3].x + x, points[3].y + y)

		b1 := Point2d(block.points[0].x + block.x, block.points[0].y + block.y)
		b2 := Point2d(block.points[1].x + block.x, block.points[1].y + block.y)
		b3 := Point2d(block.points[2].x + block.x, block.points[2].y + block.y)
		b4 := Point2d(block.points[3].x + block.x, block.points[3].y + block.y)
		
		inter  := Intersect()
		points := Point2d[][
			[f1, f2, b1, b2],
			[f1, f2, b2, b3],
			[f1, f2, b3, b4],
			[f1, f2, b4, b1],
			
			[f2, f3, b1, b2],
			[f2, f3, b2, b3],
			[f2, f3, b3, b4],
			[f2, f3, b4, b1],
			
			[f3, f4, b1, b2],
			[f3, f4, b2, b3],
			[f3, f4, b3, b4],
			[f3, f4, b4, b1],
			
			[f4, f1, b1, b2],
			[f4, f1, b2, b3],
			[f4, f1, b3, b4],
			[f4, f1, b4, b1],
		]
	
		return points.any { inter.doLinesIntersect(it) }
	}
	
//	Rect collisionRect() {
//		xs := (Float[]) points.map { it.x } 
//		ys := (Float[]) points.map { it.y } 
//		w  := xs.max - xs.min
//		h  := ys.max - ys.min
//		x  := xs.min
//		y  := ys.max
//		return Rect((this.x + x).toInt, -(this.y + y).toInt, w.toInt, h.toInt)
//	}
}

** https://martin-thoma.com/how-to-check-if-two-line-segments-intersect/
class Intersect {
	static const Float EPSILON := 0.000001f

	Bool doLinesIntersect(Point2d[] pts) {
		a := LineSegment(pts[0], pts[1])
		b := LineSegment(pts[2], pts[3])
		box1 := a.getBoundingBox
		box2 := b.getBoundingBox
		return doBoundingBoxesIntersect(box1, box2) &&
			lineSegmentTouchesOrCrossesLine(a, b) &&
			lineSegmentTouchesOrCrossesLine(b, a)
	}

	private Bool doBoundingBoxesIntersect(Point2d[] a, Point2d[] b) {
		a[0].x <= b[1].x && 
		a[1].x >= b[0].x &&
		a[0].y <= b[1].y &&
		a[1].y >= b[0].y
	}
	
	private Bool lineSegmentTouchesOrCrossesLine(LineSegment a, LineSegment b) {
		isPointOnLine(a, b.first) || 
		isPointOnLine(a, b.second) || 
		(isPointRightOfLine(a, b.first).xor(isPointRightOfLine(a, b.second)))
	}
	
	private Bool isPointOnLine(LineSegment a, Point2d b) {
		aTmp := LineSegment(Point2d(0f, 0f), Point2d(a.second.x - a.first.x, a.second.y - a.first.y))
		bTmp := Point2d(b.x - a.first.x, b.y - a.first.y)
		r := crossProduct(aTmp.second, bTmp)
		return r.abs < EPSILON
	}
	
	private Bool isPointRightOfLine(LineSegment a, Point2d b) {
		aTmp := LineSegment(Point2d(0f, 0f), Point2d(a.second.x - a.first.x, a.second.y - a.first.y))
		bTmp := Point2d(b.x - a.first.x, b.y - a.first.y)
		return crossProduct(aTmp.second, bTmp) < 0f
	}

	private Float crossProduct(Point2d a, Point2d b) {
        a.x * b.y - b.x * a.y
    }
}

class LineSegment {
    Point2d first
    Point2d second

    new make(Point2d a, Point2d b) {
        this.first = a
        this.second = b
    }

    Point2d[] getBoundingBox() {
        Point2d[
        	Point2d(first.x.min(second.x), first.y.min(second.y)),
        	Point2d(first.x.max(second.x), first.y.max(second.y))
        ]
    }
}
