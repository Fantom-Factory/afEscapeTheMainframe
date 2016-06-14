using fwt
using gfx::Color
using gfx::Image
using gfx::Brush
using afIoc

class Jump {

	@Inject Scope	scope
			Image	fanny
			Model	cube
			Model	grid
	
	new make(|This| in) {
		in(this)		
		
		cube	= Models.cube
		grid	= Models.grid {
			it.rotate(0.25f, 0f, 0f)
			it.translate(0f, -100f, 0f)
			it.colour = Color(0xFF_33_66_FF)
		}
		fanny	= Image(`fan://afDemo/res/Fanny-x80.png`)
	}

	Void draw(Gfx g) {
		g.clear(Color(0xFF_00_00_33))
		
//		g3d := Gfx3d(g.offsetCentre).lookAt(camera, Point3d(camera.x, 0f, 0f))
		g3d := Gfx3d(g.offsetCentre).lookAt(camera)

		grid.dup.translate(-x.toFloat, 0f, 0f).scale(5f, 1.0f, 1.0f).draw(g3d)

		cube.draw(g3d)

		g.drawImage(fanny, -200, 25)

//		cube.ax += 1f/100f
//		cube.ay += 1f/280f
//		cube.az -= 1f/500f

//		x += 1
//		if (x > 20)
//			x -= 20

		camera = camera.translate(0f, 1f, 0f)
		spin++
	}
	
	Float x
	Float spin
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
}
