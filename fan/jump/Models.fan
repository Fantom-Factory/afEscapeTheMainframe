using gfx::Color

class Models {
	
	static Model cube() {
		Model {
			model := it
			colour = Color.white
			
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
			
			drawables = [
				Poly([0, 1, 2, 3]).withColour(Color(0xFF_FF_FF_FF)),
				Poly([7, 6, 5, 4]).withColour(Color(0xFF_88_88_88)),
//				Poly([4, 5, 6, 7, 4]).withColour(Color(0xFF_AA_AA_AA)),
//				Poly([0, 4]),
//				Poly([1, 5]),
//				Poly([2, 6]),
//				Poly([3, 7]),
				
				Line([0, 1, 2, 3, 0]).withColour(Color(0xFF_FF_00_00)),
				Line([4, 5, 6, 7, 4]),
				Line([0, 4]),
				Line([1, 5]),
				Line([2, 6]),
				Line([3, 7]),
			]
			
			anim = |Model cube| {
//				cube.ax += 1f/100f
//				cube.ay += 1f/280f
//				cube.az -= 1f/500f
				cube.ay += 1f/500f
//				cube.z  += 1f
			}
			
			draw = |Gfx3d g3d| {
				g3d.brush = model.colour
				pts := g3d.drawModel(model)
				
				pt := model.points[0].rotate(model.ax, model.ay, model.az)
				g3d.g2d.drawFont8(pt.toStr, pts[0].x.toInt, pts[0].y.toInt)

				pt = model.points[1].rotate(model.ax, model.ay, model.az)
				g3d.g2d.drawFont8(pt.toStr, pts[1].x.toInt, pts[1].y.toInt)

				pt = model.points[2].rotate(model.ax, model.ay, model.az)
				g3d.g2d.drawFont8(pt.toStr, pts[2].x.toInt, pts[2].y.toInt)
			}			
			
			scale(0.75f)
		}
	}

	static Model grid() {
		Model {
			colour = Color(0xFF_33_66_FF)

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
			
			drawables = [
//				Poly([21, 11, 0, 10]).withColour(Color(0xFF_00_00_33)),
				Poly([10, 0, 11, 21]).withColour(Color(0xFF_00_00_33)),
				
				Line([ 0, 11]).withColour(Color(0xFF_33_66_FF)),
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
			
			it.rotate(-0.25f, 0f, 0f)
			it.translate(10f, -150f, 0f)

			model:= it
			draw = |Gfx3d g3d| {
				g3d.brush = model.colour
				pts := g3d.drawModel(model)
				
				pt := model.points[3].rotate(model.ax, model.ay, model.az)
				g3d.g2d.drawFont8(pt.toStr, pts[3].x.toInt, pts[3].y.toInt)
			}			
		}
	}

	static Model block() {
		Model {
			model := it

			points = [
				Point3d( -25f, -100f, -100f),
				Point3d(  25f, -100f, -100f),
				Point3d(  25f, -150f, -100f),
				Point3d( -25f, -150f, -100f),
				Point3d( -25f, -100f,  100f),
				Point3d(  25f, -100f,  100f),
				Point3d(  25f, -150f,  100f),
				Point3d( -25f, -150f,  100f),
			]
			
			drawables = [
				Poly([3, 2, 1, 0]).withColour(Color(0xFF_FF_33_33)),
				Poly([4, 5, 6, 7]).withColour(Color(0xFF_FF_33_33)),
				
				Line([0, 1, 2, 3, 0]).withColour(Color(0xFF_FF_FF_FF)),
				Line([4, 5, 6, 7, 4]),
				Line([0, 4]),
				Line([1, 5]),
				Line([2, 6]),
				Line([3, 7]),
			]
			
			draw = |Gfx3d g3d| {
				g3d.brush = model.colour
				g3d.drawModel(model)				
			}			
		}
	}
}
