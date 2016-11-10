using gfx::Color
using gfx::Rect

@Js
class Models {
	
	static const Color	brand_darkBlue	:= Color(0xFF_00_00_33)
	static const Color	brand_lightBlue	:= Color(0xFF_33_66_FF)
	static const Color	brand_white		:= Color(0xFF_FF_FF_FF)
	static const Color	brand_red		:= Color(0xFF_FF_22_22)
	static const Color	fanny_silver	:= Color(0xFF_DD_DD_DD)
	static const Color	block_collide	:= Color(0xFF_FF_22_22)
	static const Color	cube_fill		:= Color(0xFF_FF_FF_22)
	static const Color	cube_edge		:= brand_darkBlue

	static const Color	exitDark	:= Color(0xFF_00_33_00)
	static const Color	exitLight	:= Color(0xFF_33_FF_66)
	

	static ExitBlock exitBlock(GameData data) {
		ExitBlock(data) {
			points = [
				Point3d(   0f,  275f, -175f),
				Point3d(   0f, -25f , -175f),
				Point3d(   0f,  275f,  175f),
				Point3d(   0f, -25f ,  175f),
				
				Point3d(   0f,  50f , -175f),
				Point3d(   0f,  50f ,  175f),
				Point3d(   0f, 125f , -175f),
				Point3d(   0f, 125f ,  175f),
				Point3d(   0f, 200f , -175f),
				Point3d(   0f, 200f ,  175f),
				
				Point3d(   0f, -25f ,  -87f),
				Point3d(   0f, 275f ,  -87f),
				Point3d(   0f, -25f ,    0f),
				Point3d(   0f, 275f ,    0f),
				Point3d(   0f, -25f ,   87f),
				Point3d(   0f, 275f ,   87f),
			]
			
			drawables = [
				Fill(exitDark),
				Edge(exitLight),
				Poly([0, 1, 2, 3], true),
				Line([ 4,  5]),
				Line([ 6,  7]),
				Line([ 8,  9]),
				Line([10, 11]),
				Line([12, 13]),
				Line([14, 15]),
			]
			
			it.y = -25f - 50f - 50f
			it.x = 1000f
		}
	}
	
	static BonusCube bonusCube(GameData data, Float x, Float y) {
		BonusCube(data) {
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
			
			it.x = x
			it.y = y
			it.z = -70f

			drawables = [
				Fill(cube_fill),
				Edge(cube_edge),
				Poly([0, 1, 2, 3], false),	// front
				Poly([7, 6, 5, 4], false),	// back
				Poly([4, 0, 3, 7], false),	// left
				Poly([1, 5, 6, 2], false),	// right
				Poly([4, 5, 1, 0], false),	// top
				Poly([3, 2, 6, 7], false),	// bottom
			]					
		}
	}

	static BonusExplo bonusExplo(GameData data, Float x, Float y) {
		BonusExplo(data) {			
			it.points	 = Point3d#.emptyList
			it.drawables = Drawable#.emptyList

			a := -45 / 2f
			it.squares = (0..<8).toList.map |i| {
				BonusExploSquare(data) {
					points = [
						Point3d(-100f,  100f, 0f),
						Point3d( 100f,  100f, 0f),
						Point3d( 100f, -100f, 0f),
						Point3d(-100f, -100f, 0f),
					]
					scale(0.20f)

					drawables = [
						Fill(cube_fill),
						Edge(cube_edge),
						Poly([0, 1, 2, 3], true),
					]

					it.x = x
					it.y = y
					it.z = -70f
		
					it.movementVector = Point3d(Sin.sin(a / 360f), Sin.cos(a / 360f), 0f)
					a += 45f
				}
			}
		}
	}

	static Floor floor(GameData data) {
		Floor(data) {
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
				Poly([17, 9, 0, 8], true),
				
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

	static FloorFake fakeFloor(GameData data) {
		FloorFake(data) {
			points = [
				Point3d(-120f,  50f, 0f),
				Point3d(- 80f,  50f, 0f),
				Point3d(- 40f,  50f, 0f),
				Point3d(   0f,  50f, 0f),
				Point3d(  40f,  50f, 0f),
				Point3d(  80f,  50f, 0f),
				Point3d( 120f,  50f, 0f),

				Point3d(-120f, -50f, 0f),
				Point3d(- 80f, -50f, 0f),
				Point3d(- 40f, -50f, 0f),
				Point3d(   0f, -50f, 0f),
				Point3d(  40f, -50f, 0f),
				Point3d(  80f, -50f, 0f),
				Point3d( 120f, -50f, 0f),
			]
			rotate	(-0.25f,    0f,   0f)
			translate(  20f, -150f,   0f)
			scale	(  6.0f,   1f, 3.5f)

			drawables = [
				Fill(null),
				Edge(brand_lightBlue),
				Line([ 0,  7]),
				Line([ 1,  8]),
				Line([ 2,  9]),
				Line([ 3, 10]),
				Line([ 4, 11]),
				Line([ 5, 12]),
				Line([ 6, 13]),
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
				Poly([0, 1, 2, 3], true),	// front
				Poly([4, 0, 3, 7], false),	// left
				Poly([1, 5, 6, 2], false),	// right
				Poly([4, 5, 1, 0], false),	// top
				Poly([3, 2, 6, 7], false),	// bottom
//				Poly([7, 6, 5, 4]),	// back
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
				Poly([0, 1, 2, 3], true),	// front
				Poly([4, 0, 3, 7], false),	// left
				Poly([1, 5, 6, 2], false),	// right
				Poly([4, 5, 1, 0], false),	// top
				Poly([3, 2, 6, 7], false),	// bottom
//				Poly([7, 6, 5, 4]),	// back
				
				Fill(brand_lightBlue),
				Edge(null),
				Poly([11, 9, 10, 8], false),// eyes
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

	static FannyExplo fannyExplo(GameData data, Fanny fanny) {
		FannyExplo(data) {
			it.points	  = Point3d#.emptyList
			it.drawables = Drawable#.emptyList

			offsets := [
				[-20f+2f,  20f],
				[  0f+2f,  20f],
				[ 20f+2f,  20f],
				
				[-20f-0f,   0f],
				[  0f-0f,   0f],
				[ 20f-0f,   0f],
				
				[-40f-2f, -20f],
				[-20f-2f, -20f],
				[  0f-2f, -20f],
				[ 20f-2f, -20f],
	
				[-40f-4f, -40f],
				[-20f-4f, -40f],
				[  0f-4f, -40f],
				[ 20f-4f, -40f],
			]

			initForce	:=  3f + (Float.random * 2f)
			initY		:= 10f + (Float.random * 5f)
			initX		:= 3f + (data.level / 3f)
			index		:= 0

			it.squares = [25f, 0f, -25f].map |z| {
				offsets.map |off, i| {
					FannyExploSquare {
						it.points = [
							Point3d(-10f,  10f, 0f),
							Point3d( 10f,  10f, 0f),
							Point3d( 10f, -10f, 0f),
							Point3d(-10f, -10f, 0f),
						]

						it.drawables = [
							Fill(brand_white),
							Edge(brand_white),
							Poly([0, 1, 2, 3], true),
						]
						
						it.x = fanny.x + off[0]
						it.y = fanny.y + off[1]
						it.z = fanny.z + z
						it.index = index++

						it.movementVector = Point3d(((xMax - xMin) / 2) + off[0], ((yMax - yMin) / 2) + off[1], z)
							.translate(0f, 40f, 0f)
							.normalise
							.scale(initForce/2, initForce, initForce/2)
							.translate(initX, initY, 0f)
					}
				}
			}.flatten
		}
	}
}
