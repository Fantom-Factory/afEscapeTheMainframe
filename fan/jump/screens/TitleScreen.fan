using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope

@Js
class TitleScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
	@Inject	private FannyImages	images
			private TitleBg?	titleBg
			private TitleMenu?	titleMenu
	
	new make(|This| in) { in(this) }

	override This onInit() {
		titleBg		= TitleBg(images)
		titleMenu	= TitleMenu {
			menu.add("Start Game")
			menu.add("Hi-Scores")
			menu.add("About")
//			menu.add("Exit")	// don't know how to quit!!!
			tit := it
			go = |high| {
				if (high == 0)
					tit.anyKey = true
				if (high == 1)
					app().showHiScores
				if (high == 2)
					app().showAbout
			}
		}
		return this
	}
	
	This delay() {
		titleBg.time = 40	// no need to wait for long
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		titleMenu.keys(screen)

		if (titleMenu.anyKey) {			
			level := null as Int
			if (screen.keys[Key.num1] == true)	level = 1
			if (screen.keys[Key.num2] == true)	level = 2
			if (screen.keys[Key.num3] == true)	level = 3
			if (screen.keys[Key.num4] == true)	level = 4
			if (screen.keys[Key.num5] == true)	level = 5
			if (screen.keys[Key.num6] == true)	level = 6
			if (screen.keys[Key.num7] == true)	level = 7
			if (screen.keys[Key.num8] == true)	level = 8
			if (screen.keys[Key.num9] == true)	level = 9
			if (screen.keys[Key.num0] == true)	level = 10

			app().startGame(level)
		}

		bgGlow.draw(g2d)
		titleBg.draw(g2d)
		
		if (titleBg.time > 100) {
			titleMenu.draw(g2d)
//			str := "(c) 2016-${Date.today.year} Alien-Factory"
			str := "www.alienfactory.co.uk"
			x := 224 + ((20 - str.size) * 8 / 2)
			g2d.drawFont8(str, x, 278)
		}
	}
}

@Js
class TitleMenu {
	private Int		highlighted	:= 0
	private Bool	keyUp
	private Bool	keyDown
	private Bool	keyEnter

	Str[]	menu		:= Str[,]
	Bool	anyKey
	|Int|?	go
	
	Void draw(Gfx g2d) {
		menu.each |str, i| {
			x := 224 + ((10 - str.size) * 16 / 2)
			y := (12 * 16) + (i * 20)
			
			if (i == highlighted) {
				g2d.brush = Color.gray
				g2d.fillRoundRect(x - 2, y-1, (str.size * 16) + 4, 16+2, 5, 5)
			}
			
			g2d.drawFont16(str, x, y)
		}
	}
	
	Void keys(Screen screen) {
		anyKey = screen.keys.dup {
			remove(Key.up)
			remove(Key.down)
			remove(Key.left)
			remove(Key.right)
			remove(Key.enter)
		}.size > 0
		
		if (screen.keys[Key.up] != true)
			keyUp = false
		if (screen.keys[Key.down] != true)
			keyDown = false
		if (screen.keys[Key.enter] != true)
			keyEnter = false
		
		if (screen.keys[Key.up] == true && keyUp == false) {
			keyUp = true
			if (highlighted > 0) {
				highlighted -= 1
			}
		}

		if (screen.keys[Key.down] == true && keyDown == false) {
			keyDown = true
			if (highlighted < menu.size-1) {
				highlighted += 1
			}
		}

		if (screen.keys[Key.enter] == true && keyEnter == false) {
			keyEnter = true
			go?.call(highlighted)
		}
	}
}
