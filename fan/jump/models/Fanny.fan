using gfx::Rect

class Fanny : Model {
	Float	sy
	Bool	jumpHeld
	Bool	jumpEnabled	:= true
	Bool	squished
	Float	w
	Float	h

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
	
	new make(|This| in) : super(in) {
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
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
	
	override This anim() {
		y += sy
		if (y <= -110f) {
			y = -110f
			jumpEnabled = true 
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
	
	Rect collisionRect() {
		x := (Float) points.map { it.x + this.x }.min
		y := (Float) points.map { it.y + this.y }.max
		return Rect(x.toInt, y.toInt, w.toInt, h.toInt)
	}
}
