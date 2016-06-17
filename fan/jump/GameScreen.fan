using fwt::Key
using gfx::Color
using afIoc::Inject

class GameScreen {

	@Inject	private Screen	screen
	@Inject	private |->App|	app
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
		jump 	:= screen.keys[Key.space] == true || screen.keys[Key.up] == true
		squish	:= screen.keys[Key.down]  == true 
		ghost	:= screen.keys[Key.num1]  == true 
		fany.jump(jump)
		fany.squish(squish)
		fany.ghost(ghost)

		grid.anim
		blck.anim
		cube.anim
		fany.anim
		
		if (fany.collisionRect.intersects(blck.collisionRect)) {
			g.clear(Color.white)
			app().gameOver
		} else
			g.clear

		g3d := Gfx3d(g.offsetCentre).lookAt(camera, Point3d(0f, -25f, 0f))
		
		grid.draw(g3d)
		
		// this depends on camera angle
		if (blck.x < fany.x) {
			blck.draw(g3d)
			fany.draw(g3d)
		} else {
			fany.draw(g3d)
			blck.draw(g3d)
		}

		cube.draw(g3d)
	
//		x := 0f	//-500 * Sin.cos(ca - 0.75f)
//		y :=  500 * Sin.cos(ca - 0.75f)
//		z := -500 * Sin.sin(ca - 0.75f)
//		camera = Point3d(x, y, z)
//		ca += cas
//		if (ca > 0f || ca < -0.25f) {
//			ca -= cas
//			cas = -cas
//		}
	}
	
	Float ca	:= 0f
	Float cas	:= -0.001f
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
//	Point3d camera	:= Point3d(0f, 500f, 0f) 
}
