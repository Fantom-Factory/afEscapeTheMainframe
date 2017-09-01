using afIoc
using gfx
using fwt

@Js
class AboutScreen : GameSeg {
	
	@Inject	private Screen		screen
	@Inject	private FannySounds	sounds
	@Inject	private |->App|		app
	@Inject	private BgGlow		bgGlow
	@Inject	private Sequencer	sequencer
	
	
	new make(|This| in) {
		in(this)
	}

	override This onInit() { return this }
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d, Int catchUp) {
		sequencer.onBeat(catchUp)

		bgGlow.draw(g2d, catchUp)

		anyKey := screen.keys.size > 0 || screen.touch.swiped(Key.enter)
		if (anyKey) {
			sounds.menuSelect.play
			app().showTitles(false)
		}
		
		plot := " Fanny the Fantom has been captured by the  
		          evil Mainframe. Help Fanny escape bad 
		          programming by avoiding obstacles and 
		          collecting bonus cubes.
		          
		          Fanny must jump and duck through 10 frantic 
		          levels in this tense retro 3D vector game. 
		           
		          Can you escape the Mainframe!? 
		         "

		keys := " Touch swipe or use cursor keys to play:  
		           
		                          Up  :  Jump 
		                         Down : Squish
		          
		          Swipe or hold 'up' to jump higher.  
		          
		          Can you must master the Squish Jump to 
		          complete the game!? 
		         "
		
		
		g2d.g.brush = Models.brand_lightBlue

		halfWidth := g2d.bounds.w / 2
		g2d.drawFont16("The Plot", ((halfWidth - ("The Plot".size * 16)) / 2), 16)
		g2d.drawFont16("Keys"    , ((halfWidth - ("Keys"    .size * 16)) / 2) + halfWidth, 16)

		t1Size := "The Plot ".size * 16
		x1 := ((halfWidth - t1Size) / 2)
		x2 := x1 + t1Size
		g2d.drawLine(x1, 34, x2, 34)

		t2Size := "Keys ".size * 16
		x1 = ((halfWidth - t2Size) / 2) + halfWidth
		x2 = x1 + t2Size
		g2d.drawLine(x1, 34, x2, 34)		

		g2d.g.brush = Color.white
		g2d.g.font = Desktop.sysFontMonospace.toSize(Runtime.isJs ? 14 : 10)

		plot.splitLines.each |str, i| {
			g2d.g.drawText(str, 0, (i * 16) + 64)
		}

		keys.splitLines.each |str, i| {
			g2d.g.drawText(str, halfWidth, (i * 16) + 64)
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
