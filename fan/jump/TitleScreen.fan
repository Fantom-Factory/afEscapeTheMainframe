using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope

class TitleScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
			private TitleBg?	titleBg
			private TitleMenu?	titleMenu
	
	new make(|This| in) { in(this) }

	override This onInit() {
		titleBg		= TitleBg()
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
			}
		}
		return this
	}
	
	This delay() {
		titleBg.time = 0
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		titleMenu.keys(screen)

		if (titleMenu.anyKey) {
			app().startGame
		}

		bgGlow.draw(g2d)
		titleBg.draw(g2d)
		
		if (titleBg.time > 100) {
			titleMenu.draw(g2d)
			str := "(c) 2016-${Date.today.year} Alien-Factory"
			x := 224 + ((20 - str.size) * 8 / 2)
			g2d.drawFont8(str, x, 278)
		}
	}
}

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
			keyDown = false
			go?.call(highlighted)
		}
	}
}
