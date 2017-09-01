using gfx::Color
using gfx::Point
using gfx::Pen
using fwt::Key
using afIoc::Inject
using afIoc::Scope
using concurrent::Actor

@Js
class IntroScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
	@Inject	private FannyImages	images
	@Inject	private FannySounds	sounds
	@Inject	private Sequencer		sequencer
	@Inject	private FannySequencer	fannySequencer
			private IntroAnim?	intoAnim
	
	new make(|This| in) { in(this) }

	override This onInit() {
		fannySequencer.fadeTitleTune
		sounds.insertCoin.play
		intoAnim = IntroAnim(images, sounds, sequencer, fannySequencer)
		return this
	}
	
	This setFannyY(Float fannyY) {
		intoAnim.fannyY = fannyY
		return this
	}
	
	override Void onKill() {
		sounds.scanned.stop
	}
	
	override Void onDraw(Gfx g2d, Int catchUp) {
		sequencer.onBeat(catchUp)

		anyKey := screen.keys.size > 0 || screen.touch.swiped(Key.enter)
		if (anyKey || intoAnim.finished) {
			app().startGame(null)
		}

		bgGlow.draw(g2d, catchUp)
		intoAnim.draw(g2d, catchUp)
		
		seqs := fannySequencer.wannaPlay
		// JS Bug: see http://fantom.org/forum/topic/2629
		if (Env.cur.runtime != "js")
			seqs = seqs.unique
		seqs.each {
			if (!sequencer.has(it))
				sequencer.playNow(it)
		}
		fannySequencer.wannaPlay.clear
	}
}

@Js
class IntroAnim {
	private FannyImages		images
	private FannySounds		sounds
	private Sequencer		sequencer
	private FannySequencer	fannySequencer
	private Twean?		tweanLogoFanny
	private Twean?		tweanLogoThe
	private Twean?		tweanLogoFantom
	private TweanFanny2?tweanTheFanny
	private Twean?		tweanMonitor
	private Twean?		tweanKeyboard
	private TweanLazer?	tweanLazer1
	private TweanLazer?	tweanLazer2
	private TweanGrid?	tweanGrid
	private TweanFanny?	tweanFanny
	private TweanFloor?	tweanFloor
	
			Float 	fannyY
			Int		time	:= 1
			Bool	finished

	new make(FannyImages images, FannySounds sounds, Sequencer sequencer, FannySequencer fannySequencer) {
		this.images 		= images
		this.sounds 		= sounds
		this.sequencer 		= sequencer
		this.fannySequencer = fannySequencer
		initTweans
	}

	Void draw(Gfx g2d, Int catchUp) {
		y := (Sin.sin(fannyY) * 15f).toInt + (288 - 180) / 2
		tweanTheFanny.startY = y.toInt
		tweanTheFanny.finalY = y.toInt
		tweanFanny.fannyY = y
		fannyY += 0.007f
		if (fannyY > 1f)
			fannyY -= 1f
		
		g3d := Gfx3d(g2d).lookAtDef
		
		tweanLogoFanny	.draw(g2d, time)
		tweanLogoThe	.draw(g2d, time)
		tweanLogoFantom	.draw(g2d, time)
		tweanLazer1		.draw(g2d, time)
		tweanTheFanny	.draw2(g2d, time)
		tweanFanny		.draw(g3d, time)
		tweanLazer2		.draw(g2d, time)
		tweanMonitor	.draw(g2d, time)
		tweanKeyboard	.draw(g2d, time)
		tweanGrid		.draw(g3d, time)
		tweanFloor		.draw(g3d, time, catchUp)
		
		if (timeEq(time, 70, catchUp))
			sounds.scanned.play
		
		if (timeEq(time, 215, catchUp)) {
			tweanMonitor.with {
				it.startFrame	=  215
				it.endFrame		=  230
				it.startX		=  768 - it.imgWidth - 40
				it.startY		=  288 - it.imgHeight - 40
				it.finalX		=  768 + it.imgWidth
				it.finalY		=  288 - it.imgHeight - 40
				it.easeIn		= false
			}
		
			tweanKeyboard.with {
				it.startFrame	=  215
				it.endFrame		=  230
				it.startX		=  768 + -180 - 40
				it.startY		=  288 - it.imgHeight - 40
				it.finalX		=  768 + -180 - 40
				it.finalY		=  288 + it.imgHeight
				it.easeIn		= false
			}
		}
				
		if (timeEq(time, 210, catchUp)) {	// 210-ish! Sounds about right
			sequencer.onPlay
			fannySequencer.playMainBass	
		}
		
		finished = tweanFloor.finished
		
		time += catchUp
	}
	
	private Bool timeEq(Int time, Int val, Int catchUp) {
		time == val || (catchUp > 1 && time < val && (time + catchUp) > val)
	}

	Void initTweans() {
		tweanLogoFanny = Twean {
			it.img			= images.logoFanny
			it.imgWidth		=  409
			it.imgHeight	=  198
			it.startFrame	=    0
			it.endFrame		=   15
			it.startX		=  255
			it.startY		=  -35
			it.finalX		= it.startX
			it.finalY		= it.startY - it.imgHeight
			it.easeIn		= false
			it.endOffScreen	= true
		}
	
		tweanLogoThe = Twean {
			it.img			= images.logoThe
			it.imgWidth		=  195
			it.imgHeight	=  169
			it.startFrame	=    0
			it.endFrame		=   15
			it.startX		=  410
			it.startY		=   25
			it.finalX		= 768 + it.imgWidth
			it.finalY		= -it.imgHeight
			it.easeIn		= false
			it.endOffScreen	= true
		}
	
		tweanLogoFantom	= Twean {
			it.img			= images.logoFantom
			it.imgWidth		=  452
			it.imgHeight	=  197
			it.startFrame	=    0
			it.endFrame		=   15
			it.startX		=  360
			it.startY		=   60
			it.finalX		= it.startX + imgWidth
			it.finalY		= it.startY
			it.easeIn		= false
			it.endOffScreen	= true
		}
	
		tweanTheFanny	= TweanFanny2 {
			it.img			= images.fanny_x180
			it.imgWidth		=  180
			it.imgHeight	=  180
			it.startFrame	=    0
			it.endFrame		=    1
			it.startX		=   30
			it.startY		=    0
			it.finalX		=   30
			it.finalY		=    0
		}
	
		tweanMonitor	= Twean {
			it.img			= images.compMonitor
			it.imgWidth		=  222
			it.imgHeight	=  194
			it.startFrame	=   20
			it.endFrame		=   35
			it.startX		=  768 + it.imgWidth
			it.startY		=  288 - it.imgHeight - 40
			it.finalX		=  768 - it.imgWidth - 40
			it.finalY		=  288 - it.imgHeight - 40
		}
	
		tweanKeyboard	= Twean {
			it.img			= images.compKeyboard
			it.imgWidth		=   50
			it.imgHeight	=   23
			it.startFrame	=   20
			it.endFrame		=   35
			it.startX		=  768 + -180 - 40
			it.startY		=  288 + it.imgHeight
			it.finalX		=  768 + -180 - 40
			it.finalY		=  288 - it.imgHeight - 40
		}
		
		tweanLazer1		= TweanLazer {
			it.startFrame	=   40
			it.endFrame		=   70
			it.easeIn		= false
		}
		
		tweanLazer2		= TweanLazer {
			it.startFrame	=   60
			it.endFrame		=   90
			it.easeIn		= false
		}
		
		tweanGrid		= TweanGrid {
			it.startFrame	=   90
			it.endFrame		=  160
		}
		
		tweanFanny		= TweanFanny {
			it.startFrame	=  130
			it.endFrame		=  195
		}
		
		tweanFloor		= TweanFloor {
			it.startFrame	=  230
			it.endFrame		=  300
		}
	}
}

@Js
class TweanLazer {
	Int		startFrame
	Int		endFrame
	Float	pt1x
	Float	pt1y
	Float	pt2x
	Float	pt2y
	Bool	easeIn	:= true
	
	new make(|This| f) { f(this) }

	Void draw(Gfx g2d, Int time) {
		if (time <= startFrame)
			return
		if (time > 190)
			return
		
		monitorX := 768 - 222 - 40
		monitorY := 288 - 194 - 40

		if (time > startFrame && time <= endFrame) {
			frame := time - startFrame

			ratio := frame.toFloat / (endFrame - startFrame)
			angle := ratio * 0.25f
			if (!easeIn)
				angle += 0.25f
			sinio := Sin.sin(angle)
			if (!easeIn)
				sinio = 1f - sinio

			startX := monitorX + 130
			startY := monitorY + 100
			pt1x = ((-2 - startX) * sinio) + startX
			pt1y = ((0 - startY) * sinio) + startY

			pt2x = ((-2 - startX) * sinio) + startX
			pt2y = ((288 - startY) * sinio) + startY
		}

		if (time > 160 && time <= 195) {
			frame := time - 160

			ratio := frame.toFloat / (195 - 160)
			angle := ratio * 0.25f
			angle += 0.25f
			sinio := Sin.sin(angle)
			sinio = 1f - sinio
			
			endX := monitorX + 130
			endY := monitorY + 100
			pt1x = ((endX - -2) * sinio) + -2
			pt1y = ((endY - 0) * sinio) + 0

			pt2x = ((endX - -2) * sinio) + -2
			pt2y = ((endY - 288) * sinio) + 288
		}

		pts	:= [
			Point(pt1x.toInt, pt1y.toInt),
			Point(monitorX + 140, monitorY + 56),
			Point(monitorX + 120, monitorY + 144),
			Point(pt2x.toInt, pt2y.toInt),
		]
		
		g2d.brush = Color(0x00FF00, false)
		g2d.g.drawPolygon(pts)
		g2d.brush = Color(0x33_00FF00, true)
		g2d.brush = Color(0x2A_00FF00, true)
		g2d.g.fillPolygon(pts)
		g2d.brush = Color(0x00FF00, false)
	}
}

@Js
class TweanGrid {
	Int		startFrame
	Int		endFrame
	Model	lazerGrid	:= LazerGrid()
	
	new make(|This| f) { f(this) }

	Void draw(Gfx3d g3d, Int time) {
		if (time <= startFrame)
			return

		if (time > startFrame && time <= endFrame) {
			frame := time - startFrame

			g3d.g2d.offsetCentre
			g3d.g2d.g.pen = Pen { width = 2 }
			lazerGrid.draw(g3d)
			lazerGrid.anim

			g3d.g2d.g.pen = Pen { width = 1 }
			g3d.g2d.offset(0, 0)
		}
	}
}

@Js
class TweanFanny {
	Int		startFrame
	Int		endFrame
	Int		fannyY
	Model	fanny	:= Models.fanny(GameData(), null).scale(1.6f)
	
	new make(|This| f) { f(this) }

	Void draw(Gfx3d g3d, Int time) {
		if (time <= startFrame)
			return
		
		if (time > startFrame && time <= endFrame) {
			if (time < 150 && time.isOdd)
				return 
			
			if (time > 165 && time <= 195) {
				frame := time - 165
				
				ratio := frame.toFloat / (195 - 165)
				angle := ratio * 0.25f
				angle += 0.25f
				sinio := Sin.sin(angle)
				sinio = 1f - sinio
				
				scale := ((0.6f - 1.6f) * sinio) + 1.6f
				fanny = Models.fanny(GameData(), null).scale(scale)

				startX := -360f
				finalX := 380f
				
				startY := -fannyY + 70f
				finalY := 0f

				fanny.x = ((finalX - startX) * sinio) + startX
				fanny.y = ((finalY - startY) * sinio) + startY
				
			} else {		
				fanny.x = -360f
				fanny.y = -fannyY + 70f
			}

			
			g3d.g2d.offsetCentre
			g3d.g2d.g.pen = Pen { width = 2 }
			fanny.draw(g3d)

			g3d.g2d.g.pen = Pen { width = 1 }
			g3d.g2d.offset(0, 0)
		}
	}
}

@Js
class TweanFanny2 : Twean {
	new make(|This| f) : super.make(f) { }
	Void draw2(Gfx g2d, Int time) {
		if (time < 100)
			return draw(g2d, time)
		
		if (time > 165)
			return

		if (time.isOdd)
			return draw(g2d, time)
	}
}

@Js
class TweanFloor {
	Int		startFrame
	Int		endFrame
	Floor	floor	:= Models.floor(GameData() { it.floorSpeed = Funcs(null).funcfloorSpeed(30) }) { it.x = 1550f }
	Bool	finished
	
	new make(|This| f) { f(this) }

	Void draw(Gfx3d g3d, Int time, Int catchUp) {
		if (time <= startFrame)
			return
		
		catchUp.times {
			floor.anim
		}
		
		if (floor.x <= 0f) {
			finished = true
			Actor.locals["afFanny.floorX"] = floor.x
		}
		
		g3d.g2d.offsetCentre
		floor.draw(g3d)
		g3d.g2d.offset(0, 0)
	}
}

@Js
class LazerGrid : Model {
	
	new make() : super.make(|Model model| {
		points = [
			Point3d( 0f, -100f, -100f),
			Point3d( 0f,  100f, -100f),
			Point3d( 0f,  100f,  100f),
			Point3d( 0f, -100f,  100f),
			
			Point3d( 0f, -100f,  -50f),
			Point3d( 0f, -100f,    0f),
			Point3d( 0f, -100f,   50f),
			Point3d( 0f,  100f,  -50f),
			Point3d( 0f,  100f,    0f),
			Point3d( 0f,  100f,   50f),

			Point3d( 0f, -50f, -100f),
			Point3d( 0f,   0f, -100f),
			Point3d( 0f,  50f, -100f),
			Point3d( 0f, -50f,  100f),
			Point3d( 0f,   0f,  100f),
			Point3d( 0f,  50f,  100f),
		]
		scale(1.35f)
		
		x = -380f
		y =  0f
		z =  0f

		drawables = [
			Edge(Color(0x00FF00, false)),
			Fill(Color(0x66_00FF00, true)),
			Fill(null),
			Poly([0, 1, 2, 3], true),
			Fill(null),
			Line([4, 7]),
			Line([5, 8]),
			Line([6, 9]),
			Line([10, 13]),
			Line([11, 14]),
			Line([12, 15]),
		]
	}) { }
	
	override Void anim() {
		ax += 0.006f
	}
}