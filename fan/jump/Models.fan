using gfx::Color

class Models {
	
	static Model cube() {
		Model {
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
				Line([0, 1, 2, 3, 0]),
				Line([4, 5, 6, 7, 4]),
				Line([0, 4]),
				Line([1, 5]),
				Line([2, 6]),
				Line([3, 7]),
			]
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
		}
	}
}
