using afIoc
using gfx
using fwt

@Js
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
		
		anyKey := screen.keys.size > 0 || screen.mouseButtons.size > 0
		if (anyKey) {
			app().showTitles
		}
		
		head := "|---------------------||---------------------|
		                The Plot                 Keys
		                --------                 ----"
		
		text := " Fanny the Fantom has been captured by the  
		          evil Mainframe. Help Fanny escape bad 
		          programming by avoiding obstacles and 
		          collecting bonus cubes.
		          
		          Fanny must jump and duck through 10 frantic 
		          levels in this tense retro 3D vector game. 
		           
		          Can you escape the Mainframe!? 
		         "

		keys := "           Use cursor keys to play:  
		           
		                          Up  :  Jump 
		                         Down : Squish
		          
		          Hold 'up' to jump higher. Can you must master 
		          the Squish Jump to complete the game!? 
		           
		          Press numbers '0' to '9' to start game in  
		          training mode. Training scores are not saved.
		         "
		
		head.splitLines.each |str, i| {
			if (i == 0) return
			g2d.drawFont16(str, 0, i * 16)
		}

		text.splitLines.each |str, i| {
			g2d.drawFont8(str, 0, (i * 16)+64)
		}

		keys.splitLines.each |str, i| {
			g2d.drawFont8(str, 46*8, (i * 16)+64)
		}
		
		chars := 19
		x := ((48 - chars) * 16 / 2) - 2
		y := (16 * 16) - 1
		w := (chars * 16) + 4
		h := 16 + 2
		g2d.brush = Color.gray
		g2d.fillRoundRect(x, y, w, h, 5, 5)			
		g2d.drawFont16Centred("Return to Main Menu", 16 * 16)
	}
}
