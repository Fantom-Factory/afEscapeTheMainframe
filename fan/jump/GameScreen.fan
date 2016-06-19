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
		if (blcks.size == 0 || (blcks.last.x < -100f && blcks.size < 3)) {
//		if (data.newBlockPlease) {
			blcks.add(Models.block(data))
			data.newBlockPlease = false
		}
		
		if (!data.dying && !data.invincible) {
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
		
		if (data.deathCryIdx == 220) {
			app().gameOver
		}		
	}
	
	Void keyLogic() {
		jump 	:= screen.keys[Key.space] == true || screen.keys[Key.up] == true
		squish	:= screen.keys[Key.down]  == true 
		ghost	:= screen.keys[Key.shift] == true 
		fany.jump(jump)
		fany.squish(squish)
		fany.ghost(ghost)
		
		speed := null as Float
		if (screen.keys[Key.num1] == true)	speed = 1f
		if (screen.keys[Key.num2] == true)	speed = 2f
		if (screen.keys[Key.num3] == true)	speed = 3f
		if (screen.keys[Key.num4] == true)	speed = 4f
		if (screen.keys[Key.num5] == true)	speed = 5f
		if (screen.keys[Key.num6] == true)	speed = 6f
		if (screen.keys[Key.num7] == true)	speed = 7f
		if (screen.keys[Key.num8] == true)	speed = 8f
		if (screen.keys[Key.num9] == true)	speed = 9f
		if (speed != null) {
			data.floorSpeed = ((25f - 8f) * (speed / 9f)) + 8f
		}
	}
	
	Void anim() {
		if (!data.dying) {
			grid.anim
			blcks.each { it.anim }
			fany.anim
		}
		cube.anim
	}
	
	Void draw(Gfx g2d) {
		g2d.clear
		g3d := Gfx3d(g2d.offsetCentre).lookAt(camera, target)

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
	

//		if (screen.keys[Key.up] == true)	dy -= ds
//		if (screen.keys[Key.down] == true)	dy += ds
//		if (screen.keys[Key.left] == true)	dx -= ds
//		if (screen.keys[Key.right] == true)	dx += ds
//		ay := dy/500f
//		ax := dx/500f
//		camera = Point3d(0f, 0f, -500f).rotate(ay+0.0f, ax, 0f)
		
		delta := 110f + fany.y
		camera = Point3d(0f, 0f, -500f).translate(0f, delta / 2f, 0f) //{ echo("Cam: $it") }
		target = Point3d(0f, -75f,  0f).translate(0f, delta / 2f, 0f) //{ echo("Tar: $it") }
		
//		if (fany.squished) {
//			target = Point3d(0f, -75f, 0f).translate(0f, -50f, 0f) { echo("Tar: $it") }
//		} else
//			target = Point3d(0f, -75f, 0f)
	}
	
	Float dx	:= 0f
	Float dy	:= 0f
	Float ds	:= 1f
	
	Point3d camera	:= Point3d(0f, 0f, -500f) 
	Point3d target	:= Point3d(0f, -75f, 0f) 
}
