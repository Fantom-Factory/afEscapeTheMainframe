using fwt::Key
using gfx::Color
using gfx::Rect
using afIoc::Inject

class GameScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
			private Model?		cube
			private Model?		grid
			private Model?		collision
			private Block[]		blcks	:= Block[,]
			private Fanny?		fany
			private	GameData?	data
	
	new make(|This| in) { in(this) }

	override This onInit() {
		data	= GameData()
		blcks.clear
		collision = null
		cube	= Models.cube
		grid	= Models.grid(data)
		fany	= Models.fanny(data)
		return this
	}

	override Void onDraw(Gfx g2d) {
		keyLogic()
		gameLogic()
		anim()
		draw(g2d)
	}

	Void gameLogic() {
		blcks = blcks.exclude { it.killMe }
		if (blcks.size == 0 || (blcks[0].x < -100f && blcks.size < 3)) {
//		if (data.newBlockPlease) {
			blcks.add(Models.block(data))
			data.newBlockPlease = false
		}
		
		if (!data.dying) {
			fect  := fany.collisionRect
			crash := blcks.eachWhile |blck->Rect?| {
				col := fect.intersection(blck.collisionRect)
				return col == Rect.defVal ? null : col
			}
			if (crash != null) {
				data.dying = true
				collision = Models.collision(crash)
				
				// make transparent
				blcks.each { it.drawables[0] = Fill(null) }
			}
		}
		
		if (data.dying) {
			data.deathCryIdx++
		}
		
		if (data.deathCryIdx == 300) {
			app().gameOver
		}		
	}
	
	Void keyLogic() {
		jump 	:= screen.keys[Key.space] == true || screen.keys[Key.up] == true
		squish	:= screen.keys[Key.down]  == true 
		ghost	:= screen.keys[Key.num1]  == true 
		fany.jump(jump)
		fany.squish(squish)
		fany.ghost(ghost)
	}
	
	Void anim() {
		if (!data.dying) {
			grid.anim
			blcks.each { it.anim }
			cube.anim
			fany.anim
		}
	}
	
	Void draw(Gfx g2d) {
		g2d.clear
		g3d := Gfx3d(g2d.offsetCentre).lookAt(camera, Point3d(0f, -25f, 0f))

		grid.draw(g3d)
		
		// this depends on camera angle
		fannyDrawn := false
		blcks.each |blck| {	// blks should already X sorted
			if (blck.x < fany.x)
				blck.draw(g3d)
			else {
				if (!fannyDrawn) {
					fany.draw(g3d)
					collision?.draw(g3d)
					fannyDrawn = true
				}
				blck.draw(g3d)
			}
		}
		if (!fannyDrawn) {
			fany.draw(g3d)
			collision?.draw(g3d)
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
	
	
	static Void main(Str[] args) {
		echo("'''")
		r1 := Rect(-100, -100, 200, 200)
		echo(r1.intersection(Rect(-200,  -200, 200, 200)))
		echo(r1.intersection(Rect(   0,  -200, 200, 200)))
		echo(r1.intersection(Rect(   0,    0, 200, 200)))
		echo(r1.intersection(Rect(-200,    0, 200, 200)))
	}
}
