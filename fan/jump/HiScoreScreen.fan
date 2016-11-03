using afIoc
using gfx
using fwt

class HiScoreScreen : GameSeg {
	
	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private HiScores	hiScores
	@Inject	private BgGlow		bgGlow
			private Image?		imgScores

			private	PagesScreen?	pages
	
	
	new make(|This| f) { f(this) }

	override This onInit() {
		noOfPages := hiScores.size / 10
		if (hiScores.size % 10 > 0)
			noOfPages++
		
		pages = PagesScreen {
			it.noOfPages = noOfPages
			it.pageWidth = 768 / 2
		}

		imgScores = Image.makePainted(Size(768*10, 160+16)) |g| {
			g2d := screen.gfx(g)
			g2d.clear
			
			10.times |i| {
				line := ""
				pages.noOfPages.times |j| {
					line += hiScores[(j * 10) + i]?.toScreenStr((j * 10) + i + 1) ?: ""
				}
				g2d.drawFont16(line, 0, (i * 16)+8)
			}
		}
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		bgGlow.draw(g2d)

		pages.onJiffy(screen)
		
		if (pages.anyKey) {
			app().showTitles
		}
		
		g2d.drawFont16Centred("Fanny Hi-Scorers", 1 * 16)
		g2d.drawFont16Centred("----------------", 2 * 16)
		
		g2d.drawImage(imgScores, pages.pageX, (4 * 16)-8) 
		
//		str := (pages.page > 0 ? "<" : " ") + " ${pages.page+1} / ${pages.noOfPages+1} " + (pages.page < pages.noOfPages ? ">" : " ")
		str := (pages.page > 0 ? "<" : " ") + " ${pages.page+1} " + (pages.page < (pages.noOfPages-2) ? ">" : " ")

		g2d.brush = Color.gray
		x := ((48 - str.size) * 16 / 2) - 2
		y := (16 * 16) - 1
		w := (str.size * 16) + 4
		h := 16 + 2
		g2d.fillRoundRect(x, y, w, h, 5, 5)

		g2d.drawFont16Centred(str, 16 * 16) 
	}
}

class PagesScreen {
	private Int		scoreX
	private Int		speedX
	private Int		scoreTarget
	private Bool	keyLeft
	private Bool	keyRight
		
			Int		noOfPages
			Int		pageWidth

			Bool	anyKey
			Int		pageX
			Int		page
			Int		speed	:= 2

	new make(|This| f) { f(this) }
	
	Void onJiffy(Screen screen) {
		anyKey = screen.keys.dup {
			remove(Key.up)
			remove(Key.down)
			remove(Key.left)
			remove(Key.right)
		}.size > 0
		
		if (screen.keys[Key.left] != true)
			keyLeft = false
		
		if (screen.keys[Key.right] != true)
			keyRight = false
		
		if (screen.keys[Key.left] == true && keyLeft == false) {
			keyLeft = true
			if (scoreTarget > 0) {
				speedX = -speed
				scoreTarget -= 30
			}
		}

		if (screen.keys[Key.right] == true && keyRight == false) {
			keyRight = true
			if (scoreTarget < (30 * (noOfPages-2))) {
				speedX = speed
				scoreTarget += 30
			}
		}
		
		scoreX += speedX
		if (scoreX == scoreTarget)
			speedX = 0

		x := (scoreX / 30) * pageWidth.toFloat
		r := scoreX % 30
		if (speedX > 0) {
			x += Sin.sin(r / 30f * 0.25f) * pageWidth
		}
		if (speedX < 0) {
			x += (1-Sin.sin(0.50f - ((30f-r) / 30f * 0.25f))) * pageWidth
		}
		
		pageX = -x.toInt
		page  = scoreTarget / 30
	}
	
}