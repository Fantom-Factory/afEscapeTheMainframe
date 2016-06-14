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
			it.translate(-10f, -150f, 0f)
			it.colour = Color(0xFF_33_66_FF)
		}
		fanny	= Image(`fan://afDemo/res/Fanny-x80.png`)
	}

	Void draw(Gfx g) {
		g.clear(Color(0xFF_00_00_33))
		
		g3d := Gfx3d(g.offsetCentre).lookAt(camera, Point3d(0f, -25f, 0f))

		grid.dup.translate(-x.toFloat, 0f, 0f).scale(6.0f, 1.0f, 3.5f).draw(g3d)

		cube.draw(g3d)

		g.drawImage(fanny, -200, 25)

		cube.ax += 1f/100f
		cube.ay += 1f/280f
		cube.az -= 1f/500f

		x -= 1f
		if (x < -20f)
			x += 20f

		camera = camera.translate(0f, 0f, 0f)
	}
	
	Float x
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
}
