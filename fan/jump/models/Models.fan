using gfx::Color
using gfx::Rect

class Models {
	
	static const Color	brand_darkBlue	:= Color(0xFF_00_00_33)
	static const Color	brand_lightBlue	:= Color(0xFF_33_66_FF)
	static const Color	brand_white		:= Color(0xFF_FF_FF_FF)
	static const Color	brand_red		:= Color(0xFF_FF_22_22)
	static const Color	fanny_silver	:= Color(0xFF_DD_DD_DD)
	static const Color	block_collide	:= Color(0xFF_FF_22_22)
	static const Color	cube_yellow		:= brand_red
	static const Color	cube_edge		:= brand_white
	
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
//			scale(0.75f)
			scale(0.25f)
			x += 200
			y += 50

			drawables = [
				Fill(cube_yellow),
				Edge(cube_edge),
//				Fill(null),
				Poly([0, 1, 2, 3]),	// front
				Poly([7, 6, 5, 4]),	// back
				Poly([4, 0, 3, 7]),	// left
				Poly([1, 5, 6, 2]),	// right
				Poly([4, 5, 1, 0]),	// top
				Poly([3, 2, 6, 7]),	// bottom
				
//				Edge(brand_white),
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
			
			// draws coors on the screen
//			drawFunc = |Model model, Gfx3d g3d| {
//				pts := g3d.drawModel(model)
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
				Point3d(-160f,  50f, 0f),
				Point3d(-120f,  50f, 0f),
				Point3d(- 80f,  50f, 0f),
				Point3d(- 40f,  50f, 0f),
				Point3d(   0f,  50f, 0f),
				Point3d(  40f,  50f, 0f),
				Point3d(  80f,  50f, 0f),
				Point3d( 120f,  50f, 0f),
				Point3d( 160f,  50f, 0f),

				Point3d(-160f, -50f, 0f),
				Point3d(-120f, -50f, 0f),
				Point3d(- 80f, -50f, 0f),
				Point3d(- 40f, -50f, 0f),
				Point3d(   0f, -50f, 0f),
				Point3d(  40f, -50f, 0f),
				Point3d(  80f, -50f, 0f),
				Point3d( 120f, -50f, 0f),
				Point3d( 160f, -50f, 0f),

				Point3d(-160f,  30f, 0f),
				Point3d(-160f,  10f, 0f),
				Point3d(-160f, -10f, 0f),
				Point3d(-160f, -30f, 0f),
				Point3d(-160f, -50f, 0f),

				Point3d( 160f,  30f, 0f),
				Point3d( 160f,  10f, 0f),
				Point3d( 160f, -10f, 0f),
				Point3d( 160f, -30f, 0f),
				Point3d( 160f, -50f, 0f),
			]
			rotate	(-0.25f,  0f, 0f)
			translate(20f,  -150f, 0f)
			scale	( 6.0f,   1f, 3.5f)

			drawables = [
				Fill(brand_darkBlue),
				Edge(null),
				Poly([17, 9, 0, 8]),
				
				Edge(brand_lightBlue),
				Line([ 0,  9]),
				Line([ 1, 10]),
				Line([ 2, 11]),
				Line([ 3, 12]),
				Line([ 4, 13]),
				Line([ 5, 14]),
				Line([ 6, 15]),
				Line([ 7, 16]),
				Line([ 8, 17]),
				
				Line([ 0,  8]),
				Line([ 9, 17]),
				
				Line([18, 23]),
				Line([19, 24]),
				Line([20, 25]),
				Line([21, 26]),
				Line([22, 27]),
			]
		}
	}

	static Block block(GameData data, Int x, Int y) {
		Block(data) {
			xMax := 25f + (x * 50f);
			yMax := 25f + (y * 50f);
			points = [
				Point3d( -25f,  yMax, -175f),
				Point3d( xMax,  yMax, -175f),
				Point3d( xMax, -25f , -175f),
				Point3d( -25f, -25f , -175f),
				Point3d( -25f,  yMax,  175f),
				Point3d( xMax,  yMax,  175f),
				Point3d( xMax, -25f ,  175f),
				Point3d( -25f, -25f ,  175f),
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

			// draws coors on the screen
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
			
			// draws coors on the screen
//			drawFunc = |Model model, Gfx3d g3d| {
//				pts:=g3d.drawModel(model)
//				[1].each {
//					pt := model.points[it].rotate(model.ax, model.ay, model.az).translate(model.x, model.y, model.z)
//					g3d.drawFont8(pt.toStr, pts[it])
//				}
//			}
		}
	}
}
