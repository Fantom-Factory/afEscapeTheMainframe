using gfx::Color
using gfx::Point
using gfx::Rect
using afIoc::Inject
using afIoc::Scope
using concurrent::Actor

@Js
class OutroScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private FannySounds	sounds
	@Inject	private BgGlow		bgGlow
	@Inject	private FannyImages	images
			private OutroAnim?	outroAnim
			private Int			score
			private Int			level
			private Bool		cheating
	
	new make(|This| in) { in(this) }

	override This onInit() {
		outroAnim = OutroAnim(images, sounds)
		return this
	}
	
	This setMeta(Int score, Int level, Bool cheating) {
		this.score = score
		this.level = level
		this.cheating = cheating
		return this
	}
	
	override Void onKill() {
		sounds.deathCry.stop
	}

	override Void onDraw(Gfx g2d, Int catchUp) {
		if (outroAnim.finished) {
			app().gameOver(score, level, cheating, false)
		}

		bgGlow.draw(g2d, catchUp)
		outroAnim.draw(g2d, catchUp)	
	}
}

@Js
class OutroAnim {

	private FannyImages	images
	private FannySounds	sounds
	private TweanFanny3?tweanFanny
	private Twean?		tweanMonitor
	private Twean?		tweanKeyboard
	private TweanExplo?	tweanExplo
	
			Float 	fannyY
			Int		time	:= 1
			Bool	finished

			Point3d camera	:= Point3d(0f, 42f, -500f) 
			Point3d target	:= Point3d(0f, -75f, 0f)

	new make(FannyImages images, FannySounds sounds) {
		this.images = images
		this.sounds = sounds
		initTweans
	}

	Void draw(Gfx g2d, Int catchUp) {
		y := (Sin.sin(fannyY) * 15f).toInt + (288 - 180) / 2
		tweanFanny.finalY = y.toInt
		fannyY += 0.007f
		if (fannyY > 1f)
			fannyY -= 1f
		
		g3d := Gfx3d(g2d).lookAtDef
	
		tweanFanny		.draw2(g2d, time)
		tweanMonitor	.draw(g2d, time)
		tweanKeyboard	.draw(g2d, time)
		tweanExplo		.draw(g3d, time)
		
		if (timeEq(time, 180, catchUp)) {
			tweanFanny.with {
				it.startFrame	=  180
				it.endFrame		=  210
				it.startX		=  250
				it.startY		=  it.finalY
				it.finalX		=  FannyTheFantom.windowSize.w
				it.finalY		=    0
				it.easeIn		= false
			}
			
			tweanExplo = TweanExplo {
				it.startFrame	=  180
				it.startX		= -40f
				it.startY		=   0f
			}
		}

		if (time == tweanExplo.startFrame)
			sounds.deathCry.play
		

		finished = timeEq(time, 250, catchUp)
		
		time += catchUp
	}
	
	private Bool timeEq(Int time, Int val, Int catchUp) {
		time == val || (catchUp > 0 && time < val && (time + catchUp) > val)
	}
	
	Void initTweans() {	
		tweanMonitor	= Twean {
			it.img			= images.compMonitor
			it.imgWidth		=  222
			it.imgHeight	=  194
			it.startFrame	=   30
			it.endFrame		=   45
			it.startX		=  0 - it.imgWidth
			it.startY		=  288 - it.imgHeight - 40
			it.finalX		=  0
			it.finalY		=  288 - it.imgHeight - 40
		}
	
		tweanKeyboard	= Twean {
			it.img			= images.compKeyboard
			it.imgWidth		=   50
			it.imgHeight	=   23
			it.startFrame	=   30
			it.endFrame		=   45
			it.startX		=  0 - 222
			it.startY		=  288 - it.imgHeight - 40
			it.finalX		=  30
			it.finalY		=  288 - it.imgHeight - 40
		}

		tweanFanny	= TweanFanny3 {
			it.img			= images.fanny_x180
			it.imgWidth		=  180
			it.imgHeight	=  180
			it.startFrame	=   45
			it.endFrame		=   75
			it.startX		=  180
			it.startY		=  288 - 40 - 40
			it.finalX		=  250
			it.finalY		=    0
		}
		
		tweanExplo = TweanExplo {
			it.startFrame	=   45
			it.startX		= -300f
			it.startY		=  -60f
		}
	}
}

@Js
class TweanFanny3 : Twean {
	Int time
	new make(|This| f) : super.make(f) { }
	
	Void draw2(Gfx g2d, Int time) {
		this.time = time
		draw(g2d, time)
	}
	
	override Void doDrawImage(Gfx g2d, Int x, Int y) {
		if (time < 75) {			
			sinio := ratio(time, easeIn)
			
			w := ((imgWidth  - 40) * sinio) + 40
			h := ((imgHeight - 40) * sinio) + 40

			g2d.g.copyImage(img, Rect(0, 0, imgWidth, imgHeight), Rect(x, y, w.toInt, h.toInt))
			return 
		}

		g2d.drawImage(img, x, y)		
	}
}

@Js
class TweanExplo {
	Int			startFrame
	BonusExplo	explo
	Bool		finished
	Float		startX
	Float		startY
	
	new make(|This| f) { f(this)
		explo = Models.bonusExplo(GameData(), startX, startY)
	}

	Void draw(Gfx3d g3d, Int time) {
		if (time <= startFrame)
			return
		
		explo.anim
		
		if (explo.killMe) {
			finished = true
		}

		if (!explo.killMe) {
			g3d.g2d.offsetCentre
			explo.draw(g3d)
			g3d.g2d.offset(0, 0)
		}
	}
}
