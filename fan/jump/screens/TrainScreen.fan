using fwt::Key
using gfx::Color
using gfx::Rect
using afIoc::Inject
using afIoc::Scope

@Js
class TrainScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private FannyImages	images
	@Inject	private FannySounds	sounds
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
			private TrainMenu?	trainMenu
			private	TrainAnim?	trainAnim
	
	new make(|This| in) { in(this) }

	override This onInit() {
		trainMenu	= TrainMenu(screen, sounds) {
			menu = "1 2 3 4 5 6 7 8 9 10".split
			go 	 = |Int high| {
				app().startGame(high + 1)
			}
		}
		trainAnim = TrainAnim(images, sounds)
		
		return this
	}

	This setFannyY(Float fannyY) {
		trainAnim.fannyY = fannyY
		return this
	}

	override Void onKill() { }

	override Void onDraw(Gfx g2d, Int catchUp) {
		trainMenu.keys()

		if (trainMenu.anyKey) {			
			sounds.menuSelect.play

			level := null as Int
			if (screen.keys.pressed(Key.num1))	level = 1
			if (screen.keys.pressed(Key.num2))	level = 2
			if (screen.keys.pressed(Key.num3))	level = 3
			if (screen.keys.pressed(Key.num4))	level = 4
			if (screen.keys.pressed(Key.num5))	level = 5
			if (screen.keys.pressed(Key.num6))	level = 6
			if (screen.keys.pressed(Key.num7))	level = 7
			if (screen.keys.pressed(Key.num8))	level = 8
			if (screen.keys.pressed(Key.num9))	level = 9
			if (screen.keys.pressed(Key.num0))	level = 10

			if (level != null)
				return trainMenu.go(level-1)
			else
				return app().showTitles(false, true, trainAnim.fannyY)
		}
		
		bgGlow.draw(g2d, catchUp)
		trainAnim.draw(g2d, catchUp)
		trainMenu.draw(g2d)
	}
}

@Js
class TrainMenu {
	private Screen		screen
	private FannySounds	sounds
	private Int			highlighted	:= 0

	Str[]	menu		:= Str[,]
	Bool	anyKey
	|Int|?	go
	
	new make(Screen screen, FannySounds sounds) {
		this.screen = screen
		this.sounds = sounds
	}
	
	Void draw(Gfx g2d) {
		g2d.drawFont16("Select Training Level", 216 - 16, 13 * 16)

		menu.each |str, i| {
			x := 216 + (i * 32) - 8
			y := (15 * 16)

			if (i == highlighted) {
				g2d.brush = Color.gray
				g2d.fillRoundRect(x - 2, y-1, (str.size * 16) + 4, 16+2, 5, 5)
			}
			
			g2d.drawFont16(str, x, y)
		}
	}

	Void keys() {
		anyKey = screen.keys.dup {
			remove(Key.up)
			remove(Key.down)
			remove(Key.left)
			remove(Key.right)
			remove(Key.enter)
		}.size > 0
		
		mousePos := screen.mousePos
		if (mousePos != null)
			menu.each |str, i| {
				x := 216 + (i * 32) - 8
				y := (15 * 16)
				
				// add the border width
				if (Runtime.isJs) {
					x += 8
					y += 8
				}
				
				if (Rect(x - 2, y-1, (str.size * 16) + 4, 16+2).contains(mousePos.x, mousePos.y))
					highlighted = i
			}

		if (screen.keys.pressed(Key.left) || screen.touch.swiped(Key.left)) {
			if (highlighted > 0)
				highlighted -= 1
			else
				highlighted = menu.size-1
			sounds.menuMove.play
		}

		if (screen.keys.pressed(Key.right) || screen.touch.swiped(Key.right)) {
			if (highlighted < menu.size-1)
				highlighted += 1
			else
				highlighted = 0
			sounds.menuMove.play
		}

		if (screen.keys.pressed(Key.enter) || screen.touch.swiped(Key.enter)) {
			sounds.menuSelect.play
			go?.call(highlighted)
		}
	}
}


@Js
class TrainAnim {
	private FannyImages	images
	private FannySounds	sounds
	private Twean?		tweanTheFanny
			Float 		fannyY

	new make(FannyImages images, FannySounds sounds) {
		this.images = images
		this.sounds = sounds
		initTweans
	}

	Void draw(Gfx g2d, Int catchUp) {
		y := (Sin.sin(fannyY) * 15f).toInt + (288 - 180) / 2
		tweanTheFanny.startY = y.toInt
		tweanTheFanny.finalY = y.toInt
		fannyY += 0.007f
		if (fannyY > 1f)
			fannyY -= 1f
		
		tweanTheFanny.draw(g2d, 1)
		g2d.drawImage(images.logoFanny,	 255, -35)
		g2d.drawImage(images.logoThe,	 410,  25)
		g2d.drawImage(images.logoFantom, 360,  60)

	}
	
	Void initTweans() {
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
	}
}