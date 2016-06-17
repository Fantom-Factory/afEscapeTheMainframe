using gfx::Color
using gfx::Rect

class Models {
	
	static const Color	brand_darkBlue	:= Color(0xFF_00_00_33)
	static const Color	brand_lightBlue	:= Color(0xFF_33_66_FF)
	static const Color	brand_white		:= Color(0xFF_FF_FF_FF)
	static const Color	brand_red		:= Color(0xFF_FF_22_22)
	static const Color	fanny_silver	:= Color(0xFF_DD_DD_DD)
	
	static Model cube() {
		Model {
			points = [
				Point3d(-100f,  100f, -100f),
				Point3d( 100f,  100f, -100f),
				Point3d( 100f, -100f, -100f),
				Point3d(-100f, -100f, -100f),
				Point3d(-100f,  100f,  100f),
				Point3d( 100f,  100f,  100f),
				Point3d( 100f, -100f,  100f),
				Point3d(-100f, -100f,  100f),
			]
			scale(0.25f)
			x += 100
			y += 50

			drawables = [
				Fill(brand_red),
				Edge(brand_white),
				Poly([0, 1, 2, 3]),	// front
				Poly([7, 6, 5, 4]),	// back
				Poly([4, 0, 3, 7]),	// left
				Poly([1, 5, 6, 2]),	// right
				Poly([4, 5, 1, 0]),	// top
				Poly([3, 2, 6, 7]),	// bottom
				
//				Misc(brand_white),
//				Line([0, 1, 2, 3, 0]),
//				Line([4, 5, 6, 7, 4]),
//				Line([0, 4]),
//				Line([1, 5]),
//				Line([2, 6]),
//				Line([3, 7]),
			]
			
			animFunc = |Model cube| {
				cube.ax += 1f/100f
				cube.ay += 1f/280f
				cube.az -= 1f/500f
			}
			
//			drawFunc = |Model model, Gfx3d g3d| {
//				pts := g3d.drawModel(model)
//				
//				[0, 1, 2].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az)
//					g3d.drawFont8(pt.toStr, pts[it])					
//				}
//			}						
		}
	}

	static Model grid() {
		Model {
			points = [
				Point3d(-100f,  50f, 0f),
				Point3d(- 80f,  50f, 0f),
				Point3d(- 60f,  50f, 0f),
				Point3d(- 40f,  50f, 0f),
				Point3d(- 20f,  50f, 0f),
				Point3d(   0f,  50f, 0f),
				Point3d(  20f,  50f, 0f),
				Point3d(  40f,  50f, 0f),
				Point3d(  60f,  50f, 0f),
				Point3d(  80f,  50f, 0f),
				Point3d( 100f,  50f, 0f),

				Point3d(-100f, -50f, 0f),
				Point3d(- 80f, -50f, 0f),
				Point3d(- 60f, -50f, 0f),
				Point3d(- 40f, -50f, 0f),
				Point3d(- 20f, -50f, 0f),
				Point3d(   0f, -50f, 0f),
				Point3d(  20f, -50f, 0f),
				Point3d(  40f, -50f, 0f),
				Point3d(  60f, -50f, 0f),
				Point3d(  80f, -50f, 0f),
				Point3d( 100f, -50f, 0f),

				Point3d(-100f,  30f, 0f),
				Point3d(-100f,  10f, 0f),
				Point3d(-100f, -10f, 0f),
				Point3d(-100f, -30f, 0f),
				Point3d(-100f, -50f, 0f),

				Point3d( 100f,  30f, 0f),
				Point3d( 100f,  10f, 0f),
				Point3d( 100f, -10f, 0f),
				Point3d( 100f, -30f, 0f),
				Point3d( 100f, -50f, 0f),
			]
			rotate	(-0.25f,  0f, 0f)
			translate(10f,  -150f, 0f)
			scale	( 6.0f,   1f, 3.5f)
			
			drawables = [
				Fill(brand_darkBlue),
				Edge(null),
				Poly([21, 11, 0, 10]),
				
				Edge(brand_lightBlue),
				Line([ 0, 11]),
				Line([ 1, 12]),
				Line([ 2, 13]),
				Line([ 3, 14]),
				Line([ 4, 15]),
				Line([ 5, 16]),
				Line([ 6, 17]),
				Line([ 7, 18]),
				Line([ 8, 19]),
				Line([ 9, 20]),
				Line([10, 21]),
				
				Line([ 0, 10]),
				Line([11, 21]),
				
				Line([22, 27]),
				Line([23, 28]),
				Line([24, 29]),
				Line([25, 30]),
				Line([26, 31]),
			]

//			drawFunc = |Model model, Gfx3d g3d| {
//				pts := g3d.drawModel(model)
//				
//				[0, 10, 11, 21].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az)
//					g3d.drawFont8(pt.toStr, pts[it])					
//				}
//			}

			animFunc = |Model model| {
				model.x -= 12f
				if (model.x < -120f)
					model.x += 120f
			}
		}
	}

	static Block block() {
		Block {
			points = [
				Point3d( -25f, -100f, -175f),
				Point3d(  25f, -100f, -175f),
				Point3d(  25f, -150f, -175f),
				Point3d( -25f, -150f, -175f),
				Point3d( -25f, -100f,  175f),
				Point3d(  25f, -100f,  175f),
				Point3d(  25f, -150f,  175f),
				Point3d( -25f, -150f,  175f),
			]
			
			drawables = [
				Fill(brand_darkBlue),
				Edge(brand_lightBlue),
				Poly([0, 1, 2, 3]),	// front
				Poly([7, 6, 5, 4]),	// back
				Poly([4, 0, 3, 7]),	// left
				Poly([1, 5, 6, 2]),	// right
				Poly([4, 5, 1, 0]),	// top
				Poly([3, 2, 6, 7]),	// bottom
			]

			it.x = 600f
			
			animFunc = |Model model| {
				model.x -= 12f
				if (model.x < -600f)
					model.x += 1200f
			}

//			drawFunc = |Model model, Gfx3d g3d| {
//				pts:=g3d.drawModel(model)
//				[1, 2].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az)
//					g3d.drawFont8("$it : $pt", pts[it])					
//				}
//			}
		}
	}

	static Fanny fanny() {
		Fanny {
			points = [
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
			
			drawables = [
				Fill(fanny_silver),
				Edge(brand_white),
				Poly([0, 1, 2, 3]),	// front
				Poly([7, 6, 5, 4]),	// back
				Poly([4, 0, 3, 7]),	// left
				Poly([1, 5, 6, 2]),	// right
				Poly([4, 5, 1, 0]),	// top
				Poly([3, 2, 6, 7]),	// bottom
				
				Fill(brand_lightBlue),
				Edge(null),
				Poly([11, 9, 10, 8]),	// eyes
			]

			it.x = -240f
			it.y = -110f
			it.z = -70f
			
			animFunc = |Model model| {
			//	model.ay -= 1f/800f
			}

//			drawFunc = |Model model, Gfx3d g3d| {
//				pts:=g3d.drawModel(model)
//				[1, 2].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az).translate(model.x, model.y, model.z)
//					g3d.drawFont8(pt.toStr, pts[it])
//				}
//			}

		}
	}
}

class Fanny : Model {
	Float	sy
	Bool	jumpHeld
	Bool	jumpEnabled	:= true
	Float	w
	Float	h

	new make(|This| in) : super(in) {
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
	}

	Void jump() {
		if (jumpEnabled || jumpHeld) {
			sy += 15f
			sy = sy.min(15f)
			
			jumpEnabled = false
			jumpHeld = true
			
			if (y > 25f)
				jumpHeld = false
		}
	}

	Void noJump() {
		jumpHeld = false
	}
	
	override This anim() {
		y += sy
		if (y <= -110f) {
			y = -110f
			jumpEnabled = true 
		}

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

class Block : Model {
	Float	w
	Float	h
	
	new make(|This| in) : super(in) {
		xs := (Float[]) points.map { it.x } 
		ys := (Float[]) points.map { it.y } 
		w = xs.max - xs.min
		h = ys.max - ys.min
	}

	Rect collisionRect() {
		x := (Float) points.map { it.x + this.x }.min
		y := (Float) points.map { it.y + this.y }.max
		return Rect(x.toInt, y.toInt, w.toInt, h.toInt)
	}
}
