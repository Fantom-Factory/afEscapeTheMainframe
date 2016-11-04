using fwt::Key
using gfx::Color
using gfx::Rect
using gfx::Image
using afIoc::Inject
using afIoc::Autobuild

@Js
class GameScreen : GameSeg {

	@Inject		private Screen			screen
	@Inject		private |->App|			app
	@Inject		private BgGlow			bgGlow
	@Autobuild	private	Funcs			funcs
				private BonusCube[]		bonusCubes	:= BonusCube[,]
				private BonusExplo[]	bonusExplo	:= BonusExplo[,]
				private Model?			grid
				private Block[]			blcks		:= Block[,]
				private Fanny?			fanny
				private FannyExplo?		fannyExplo
				private GameHud			gameHud		:= GameHud()
				private	GameData?		data
	
	
	new make(|This| in) { in(this) }

	override This onInit() {
		data	= GameData()
		blcks.clear
		grid	= Models.grid(data)
		fanny	= Models.fanny(data)
		bonusCubes.clear
		bonusExplo.clear
		fannyExplo = null
		return this
	}
	
	This trainingLevel(Int? level) {
		if (level != null) {
			data.level = level
			data.training = true
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
		
		data.level		= funcs.funcLevel(data)
		data.floorSpeed	= funcs.funcfloorSpeed(data.level)
		
		data.distSinceLastBlock += data.floorSpeed
		data.newBlockPlease = funcs.funcNewBlock(data.level, data.distSinceLastBlock, data.floorSpeed)
		
		if (data.newBlockPlease) {
			data.newBlockPlease 	= false

			// FIXME Top block MUST be drawn first! And then fanny in the middle
			blks := funcs.funcBlock(data, data.level, data.distSinceLastBlock, blcks.last)
			blcks.addAll(blks)
			
			bonusCube := funcs.funcBonusCube(data, blks.first)
			if (bonusCube != null)
				bonusCubes.add(bonusCube)

			// set by funcBlock
//			data.distSinceLastBlock = 0f
		}
		
		if (!data.dying) {
			crash := blcks.any |blck| {
				col := fanny.intersects(blck)
				
				if (!col) {
					blck.drawables[0] = Fill(Models.brand_darkBlue)
					blck.drawables[1] = Edge(Models.brand_lightBlue)
					return false
				}
				
				blck.drawables[0] = Fill(Models.block_collide)
				blck.drawables[1] = Edge(Models.brand_white)
				return col
			}

			if (crash && !data.invincible) {
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
				}
			}
		}
		
		if (data.dying) {
			data.deathCryIdx++
		
			if (data.deathCryIdx == 180) {
				app().gameOver(data.score, data.training)
			}
		}
	}
	
	Void keyLogic() {
		jump 	:= screen.keys[Key.space] == true || screen.keys[Key.up] == true
		squish	:= screen.keys[Key.down]  == true 
		fanny.jump(jump)
		fanny.squish(squish)

		if (screen.keys[Key.esc] == true)	gameOver()
	}
	
	Void anim() {
		grid.anim
		blcks.each { it.anim }
		if (!data.dying)
			fanny.anim
		fannyExplo?.anim
		
		bonusCubes.each { it.anim }
		bonusCubes = bonusCubes.exclude { it.killMe }
		
		bonusExplo.each { it.anim }
		bonusExplo = bonusExplo.exclude { it.killMe }
	}
	
	Void draw(Gfx g2d) {
		bgGlow.draw(g2d, data.level)
		
		g3d := Gfx3d(g2d.offsetCentre).lookAt(camera, target)

		grid.draw(g3d)
		
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
	}
	
	
	Float dx	:= 0f
	Float dy	:= 0f
	Float ds	:= 1f
	
	Point3d camera	:= Point3d(0f, 42f, -500f) 
	Point3d target	:= Point3d(0f, -75f, 0f)
}