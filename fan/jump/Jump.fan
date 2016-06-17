using fwt
using gfx::Color
using gfx::Image
using gfx::Brush
using afIoc

class Jump {

	@Inject	private Screen	screen
			private Model	cube
			private Model	grid
			private Block	blck
			private Fanny	fany
	
	new make(|This| in) {
		in(this)		
		
		cube	= Models.cube
		grid	= Models.grid
		blck	= Models.block
		fany	= Models.fanny
	}

	Void draw(Gfx g) {

		if (screen.keys[Key.space] == true || screen.keys[Key.up] == true)
			fany.jump
		else
			fany.noJump

		grid.anim
		blck.anim
		cube.anim
		fany.anim
		
		if (fany.collisionRect.intersects(blck.collisionRect))
			g.clear(Color.white)
		else
			g.clear

		g3d := Gfx3d(g.offsetCentre).lookAt(camera, Point3d(0f, -25f, 0f))
		
		grid.draw(g3d)
		cube.draw(g3d)
		
		// this depends on camera angle
		if (blck.x < fany.x) {
			blck.draw(g3d)
			fany.draw(g3d)
		} else {
			fany.draw(g3d)
			blck.draw(g3d)
		}
	
//		camera = camera.translate(-1f, 0f, 0f)
	}
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
//	Point3d camera	:= Point3d(0f, 500f, 0f) 
}
