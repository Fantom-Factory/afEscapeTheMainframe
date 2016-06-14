
class Models {
	
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
			
			lines = [
				[0, 1, 2, 3, 0],
				[4, 5, 6, 7, 4],
				[0, 4],
				[1, 5],
				[2, 6],
				[3, 7],
			]
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
			
			lines = [
				[ 0, 11],
				[ 1, 12],
				[ 2, 13],
				[ 3, 14],
				[ 4, 15],
				[ 5, 16],
				[ 6, 17],
				[ 7, 18],
				[ 8, 19],
				[ 9, 20],
				[10, 21],
				
				[ 0, 10],
				[11, 21],
				
				[22, 27],
				[23, 28],
				[24, 29],
				[25, 30],
				[26, 31],
			]
		}
	}
}
