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

	static Model grid(GameData data) {
		Grid(data) {
			// (-480 -> 720, -150, -175 -> 175)
			points = [
				Point3d(-100f,  50f, 0f),
				Point3d(- 60f,  50f, 0f),
				Point3d(- 20f,  50f, 0f),
				Point3d(  20f,  50f, 0f),
				Point3d(  60f,  50f, 0f),
				Point3d( 100f,  50f, 0f),

				Point3d(-100f, -50f, 0f),
				Point3d(- 60f, -50f, 0f),
				Point3d(- 20f, -50f, 0f),
				Point3d(  20f, -50f, 0f),
				Point3d(  60f, -50f, 0f),
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
			translate(20f,  -150f, 0f)
			scale	( 6.0f,   1f, 3.5f)

			drawables = [
				Fill(brand_darkBlue),
				Edge(null),
				Poly([11, 6, 0, 5]),
				
				Edge(brand_lightBlue),
				Line([ 0,  6]),
				Line([ 1,  7]),
				Line([ 2,  8]),
				Line([ 3,  9]),
				Line([ 4, 10]),
				Line([ 5, 11]),
				
				Line([ 0,  5]),
				Line([ 6, 11]),
				
				Line([12, 17]),
				Line([13, 18]),
				Line([14, 19]),
				Line([15, 20]),
				Line([16, 21]),
			]
		}
	}

	static Block block(GameData data) {
		Block(data) {
			points = [
				Point3d( -25f,  25f, -175f),
				Point3d(  25f,  25f, -175f),
				Point3d(  25f, -25f, -175f),
				Point3d( -25f, -25f, -175f),
				Point3d( -25f,  25f,  175f),
				Point3d(  25f,  25f,  175f),
				Point3d(  25f, -25f,  175f),
				Point3d( -25f, -25f,  175f),
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

//			drawFunc = |Model model, Gfx3d g3d| {
//				pts:=g3d.drawModel(model)
//				[3].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az).translate(model.x, model.y, model.z)
//					g3d.drawFont8(pt.toStr, pts[it])
//				}
//			}
		}
	}

	static Fanny fanny(GameData data) {
		Fanny(data) {
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
			
//			drawFunc = |Model model, Gfx3d g3d| {
//				pts:=g3d.drawModel(model)
//				[1].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az).translate(model.x, model.y, model.z)
//					g3d.drawFont8(pt.toStr, pts[it])
//				}
//			}
		}
	}

	static Model collision(Rect rect) {
		Model {
			xMin := (rect.x + rect.w).min(rect.x).toFloat
			xMax := (rect.x + rect.w).max(rect.x).toFloat
			yMax := (rect.y + rect.h).min(rect.y).toFloat.negate
			yMin := (rect.y + rect.h).max(rect.y).toFloat.negate

			points = [
				Point3d( xMin, yMax, -35f),
				Point3d( xMax, yMax, -35f),
				Point3d( xMax, yMin, -35f),
				Point3d( xMin, yMin, -35f),
				Point3d( xMin, yMax,  35f),
				Point3d( xMax, yMax,  35f),
				Point3d( xMax, yMin,  35f),
				Point3d( xMin, yMin,  35f),
			]
			
			drawables = [
				Fill(Color(0xFF_FF_22_22)),
				Edge(brand_white),
				Poly([0, 1, 2, 3]),	// front
				Poly([7, 6, 5, 4]),	// back
				Poly([4, 0, 3, 7]),	// left
				Poly([1, 5, 6, 2]),	// right
				Poly([4, 5, 1, 0]),	// top
				Poly([3, 2, 6, 7]),	// bottom
			]
			
			z = -70f
		}
	}
}
