using fwt::Key
using gfx::Color
using gfx::Rect
using gfx::Image
using gfx::Point
using afIoc::Inject
using afIoc::Autobuild
using concurrent::Actor

@Js
class GameScreen : GameSeg {

	@Inject		private Screen			screen
	@Inject		private |->App|			app
	@Inject		private BgGlow			bgGlow
	@Inject		private FloorCache		floorCache
	@Autobuild	private	Funcs			funcs
				private BonusCube[]		bonusCubes	:= BonusCube[,]
				private BonusExplo[]	bonusExplo	:= BonusExplo[,]
				private FloorFake?		floor
				private Block[]			blcks		:= Block[,]
				private Fanny?			fanny
				private FannyExplo?		fannyExplo
				private ExitBlock?		exitBlock
				private GameHud			gameHud		:= GameHud()
				private	GameData?		data
	
	new make(|This| in) { in(this) }

	override This onInit() {
		data	= GameData()
		blcks.clear
		floor	= Models.fakeFloor(data, floorCache) { it.x = Actor.locals["afFanny.floorX"] ?: 0f }
		fanny	= Models.fanny(data) { it.y = 200f }
		bonusCubes.clear
		bonusExplo.clear
		fannyExplo = null
		exitBlock = null
		
		gameHud	= GameHud()
		gameHud.alertGameStart
		return this
	}
	
	This trainingLevel(Int? level) {
		if (level != null) {
			data.level = level
			data.training = true
			gameHud.alertTraining(level)
		}
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		keyLogic()
		gameLogic()
		anim()
		draw(g2d)
	}
	
	Void gameLogic() {
		blcks = blcks.exclude { it.killMe }
		
		oldLevel := data.level
		data.level		= funcs.funcLevel(data)
		data.floorSpeed	= funcs.funcfloorSpeed(data.level)
		
		if (oldLevel != data.level)
			gameHud.alertLevelUp(data.level)

		if (data.level == 11)
			data.invincible = 2000	// so fanny doesn't get killed by the blocks already on the screen
		
		data.distSinceLastBlock += data.floorSpeed
		data.newBlockPlease = funcs.funcNewBlock(data.level, data.distSinceLastBlock, data.floorSpeed)
		
		if (data.newBlockPlease) {
			data.newBlockPlease = false

			if (data.level == 11) {
				data.distSinceLastBlock = 0f
				
				if (exitBlock == null) {
					exitBlock = Models.exitBlock(data)
				}
				
			} else {			
				// FIXME Top block MUST be drawn first! And then fanny in the middle
				blks := funcs.funcBlock(data, data.level, data.distSinceLastBlock, blcks.last)
				blcks.addAll(blks)
				
				bonusCube := funcs.funcBonusCube(data, blks.first)
				if (bonusCube != null)
					bonusCubes.add(bonusCube)

				// set by funcBlock
//				data.distSinceLastBlock = 0f
			}
		}
		
		if (!data.dying) {
			crash := blcks.any |blck| {
				col := fanny.intersects(blck)
				
				if (!col) {
//					blck.drawables[0] = Fill(Models.brand_darkBlue)
//					blck.drawables[1] = Edge(Models.brand_lightBlue)
					return false
				}
				
				blck.drawablesDup[0] = Fill(Models.block_collide)
				blck.drawablesDup[1] = Edge(Models.brand_white)
				return col
			}

			if (crash && !data.isInvincible) {
				gameOver()
			}
			
			fannyXmin	:= fanny.xMin
			blcks.each |blck| {
				if (blck.score > 0) {
					if (blck.xMax < fannyXmin) {
						data.blocksJumpedInGame++
						data.blocksJumpedInLevel++
						data.score += blck.score
						blck.score = 0
					}
				}
			}
		}
		
		if (!data.dying) {
			fannyRect := fanny.collisionRect
			bonusCubes.each |cube| {
				col := cube.collisionRect.intersects(fannyRect)
				if (col) {
					data.score += 15
					cube.killMe = true
					
					explo := Models.bonusExplo(data, cube.x, cube.y)
					bonusExplo.add(explo)
					
					data.invincible = 40
				}
			}
		}
		
		if (data.dying) {
			data.deathCryIdx++
		
			if (data.deathCryIdx == 160) {
				gameReallyOver()
			}
		}
	}
	
	Bool?	touchUp
	Void keyLogic() {
		jump 	:= screen.keys.down(Key.up  ) || screen.keys.down(Key.w) || screen.keys.down(Key.space)
		squish	:= screen.keys.down(Key.down) || screen.keys.down(Key.s)  

		
		if (screen.mouseButtons[1] == true) {
			tSquish := true
			tJump	:= false

			if (screen.touch.moving(Key.up)) {
				touchUp = true
				tSquish = false
				tJump	= true
			}

			if (touchUp == true) {
				tSquish = false
				tJump	= true
			}

			if (screen.touch.moving(Key.down)) {
				touchUp = false
				tSquish = true
				tJump	= false
			}
			
			if (tSquish)	squish = true
			if (tJump)		jump = true

		} else
			touchUp = null

		fanny.jump(jump)
		fanny.squish(squish)

		if (screen.keys.pressed(Key.g) && exitBlock == null) {
			data.level = 11
			gameHud.alertLevelUp(data.level)
		}
		
		if (!data.dying)
			if (screen.keys.pressed(Key.esc))
				gameOver()			

		if (data.dying)
			if (screen.keys.pressed(Key.esc) || screen.touch.swiped(Key.enter))
				gameReallyOver()
	}
	
	Void anim() {
		floor.anim
		blcks.each { it.anim }
		if (!data.dying)
			fanny.anim
		fannyExplo?.anim
		
		fanny.ghost(data.isInvincible)
		if (data.isInvincible)
			data.invincible--
		
		bonusCubes.each { it.anim }
		bonusCubes = bonusCubes.exclude { it.killMe }
		
		bonusExplo.each { it.anim }
		bonusExplo = bonusExplo.exclude { it.killMe }
		
		exitBlock?.anim
		if (exitBlock != null && exitBlock.x <= fanny.x)
			gameOver()
	}
	
	Void draw(Gfx g2d) {
		bgGlow.draw(g2d, data.level)
		
		g3d := Gfx3d(g2d.offsetCentre).lookAt(camera, target)

		floor.draw(g3d)
		
		// this depends on camera angle
		fannyDrawn	:= false
		fannyXmin	:= fanny.xMin
		
		bonusCubes.each { it.drawn = false }
		
		blcks.findAll { it.x < 0f }.each |blck| {
			if (blck.xMax < fannyXmin) {
				
				if (blck.bonusCube != null && blck.bonusCube.y < blck.y)
					blck.bonusCube.draw(g3d)
				blck.draw(g3d)
				
			} else {
				if (!fannyDrawn) {
					fanny.draw(g3d)
					fannyDrawn = true
				}

				if (blck.bonusCube != null && blck.bonusCube.y < blck.y)
					blck.bonusCube.draw(g3d)
				blck.draw(g3d)
			}
			
			blck.bonusCube?.draw(g3d)
		}
		blcks.findAll { it.x >= 0f }.sortr |b1, b2| { b1.x <=> b2.x  }.each |blck| {
			if (blck.bonusCube != null && blck.bonusCube.y < blck.y)
				blck.bonusCube.draw(g3d)
			blck.draw(g3d)
			blck.bonusCube?.draw(g3d)
		}
		
		
		if (!fannyDrawn)
			fanny.draw(g3d)
		
		fannyExplo?.draw(g3d)
		
		bonusCubes.each { it.draw(g3d) }
		bonusExplo.each { it.draw(g3d) }
		
		gameHud.draw(g2d, data)

		if (exitBlock?.killMe != true)
			exitBlock?.draw(g3d)
			
		
//		if (screen.keys[Key.left]  == true)	data.floorSpeed -= 0.5f
//		if (screen.keys[Key.right] == true)	data.floorSpeed += 0.5f		
		
//		if (screen.keys[Key.up]    == true)	dy -= ds
//		if (screen.keys[Key.down]  == true)	dy += ds
//		if (screen.keys[Key.left]  == true)	dx -= ds
//		if (screen.keys[Key.right] == true)	dx += ds
//		ay := dy/500f
//		ax := dx/500f
//		camera = Point3d(0f, 0f, -500f).rotate(ay+0.0f, ax, 0f)
		
		// uncomment to alter camera view
//		delta := 110f + fanny.y
//		camera = Point3d(0f, 0f, -500f).translate(0f, delta / 2f, 0f) //{ echo("Cam: $it") }
//		target = Point3d(0f, -75f,  0f).translate(0f, delta / 2f, 0f) //{ echo("Tar: $it") }
	}
	
	Void gameOver() {
		if (data.dying) return
		
		data.dying = true

		fannyExplo = Models.fannyExplo(data, fanny)
		
		if (data.level != 11)
			gameHud.alertGameOver
		
		screen.keys.clear
		screen.touch.clear
		screen.mouseButtons.clear
	}
	
	Void gameReallyOver() {
		app().gameOver(data.score, data.level, data.training, true)
	}
	
	Float dx	:= 0f
	Float dy	:= 0f
	Float ds	:= 1f
	
	Point3d camera	:= Point3d(0f, 42f, -500f) 
	Point3d target	:= Point3d(0f, -75f, 0f)
}
