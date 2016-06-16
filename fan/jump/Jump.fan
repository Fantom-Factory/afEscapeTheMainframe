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
			Model	blck
	
	new make(|This| in) {
		in(this)		
		
		cube	= Models.cube
		grid	= Models.grid
		blck	= Models.block
		fanny	= Image(`fan://afDemo/res/Fanny-x80.png`)
	}

	Void draw(Gfx g) {
		g3d := Gfx3d(g.offsetCentre).lookAt(camera, Point3d(0f, -25f, 0f))

		grid.dup.translate(x.toFloat, 0f, 0f).scale(6.0f, 1.0f, 3.5f).draw(g3d)
		blck.dup.scale(1.0f, 1.0f, 1.75f).draw(g3d)
		cube.draw(g3d)

		g.drawImage(fanny, -200, 25)

		cube.anim(cube)
	
		x -= 1f
		if (x < -20f)
			x += 20f

		blck.x -= 1f

//		camera = camera.translate(-1f, -1f, 0f)
	}
	
	Float x
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
//	Point3d camera	:= Point3d(0f, 500f, 0f) 
}
