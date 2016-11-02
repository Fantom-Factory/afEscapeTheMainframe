using afIoc
using gfx
using fwt

class AboutScreen : GameSeg {
	
	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
//			private Image?		imgScores

//			private	PagesScreen	pages
	
	
	new make(|This| in) {
		in(this)
//		pages = PagesScreen {
//			it.noOfPages = 8
//			it.pageWidth = 768 / 2
//		}
	}

	override This onInit() {
//		imgScores = Image.makePainted(Size(768*10, 160+16)) |g| {
//			g2d := screen.gfx(g)
//			g2d.clear
//
//			10.times |i| {
//				line := ""
//				10.times |j| {
//					line += hiScores[(j * 10) + i].toScreenStr((j * 10) + i + 1)
//				}
//				g2d.drawFont16(line, 0, (i * 16)+8)
//			}
//		}
		return this
	}
	
	override Void onKill() {
	}

	override Void onDraw(Gfx g2d) {
		bgGlow.draw(g2d)

//		pages.onJiffy(screen)
		
		anyKey := screen.keys.size > 0
		if (anyKey) {
			app().showTitles
		}
		
		text := "|---------------------||---------------------|
		            Fanny the Fantom
		            ----------------
		         
		         Fanny has been caputred
		         by Bad Programming.
		         
		         Help Fanny escape by 
		         avoiding obstacles and
		         collecting bonus cubes.
		         "
		
		text.splitLines.each |str, i| {
			if (i == 0) return
			g2d.drawFont16(str, 0, i * 16)
		}
	}
}
