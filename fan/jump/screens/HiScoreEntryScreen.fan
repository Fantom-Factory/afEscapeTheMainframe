using afIoc
using gfx
using fwt

@Js
class HiScoreEntryScreen : GameSeg {
	
	@Inject	private Screen		screen
	@Inject	private FannySounds	sounds
	@Inject	private |->App|		app
	@Inject	private HiScores	hiScores
	@Inject	private BgGlow		bgGlow
			private	Int			newPosition
			private Int			newScore
			private Str			newName	:= ""
			private Int			screenPos
			private Int			minPos
			private Int			maxPos
			private HiScore[]	scores	:= HiScore#.emptyList
			private Int			level

	new make(|This| f) { f(this) }

	override This onInit() {
		sounds.winner.play
		return this
	}
	
	This setScore(Int score, Int level) {
		this.level	= level
		newPosition = hiScores.newPosition(score)
		newScore	= score
		newName		= ""
		
		screen.editText = ""
		screen.editMode = true
		hiScores.editing = true
		
		screenPos = 5
		minPos = newPosition - 5
		maxPos = newPosition + 5

		if (newPosition < 5 || hiScores.size < 11) {
			minPos = 0
			screenPos = newPosition
			maxPos = 11.min(hiScores.size)
		} else
		if (newPosition >= hiScores.size - 5) {
			minPos = hiScores.size - 11
			screenPos = newPosition - (hiScores.size - 11)
			maxPos = hiScores.size
		}
		
		scores = hiScores[minPos..<maxPos]
		return this
	}
	
	override Void onKill() {
		screen.editMode = false
		sounds.winner.stop
	}

	override Void onDraw(Gfx g2d, Int catchUp) {
		bgGlow.draw(g2d, catchUp)
	
		if (screen.editText.size > HiScores.maxNameSize)
			screen.editText = screen.editText[0..<HiScores.maxNameSize]

		if (newName != screen.editText) {
			newName = screen.editText
			hiScores[newPosition].name = screen.editText
		}
		
		// touch screens can't bring up a keyboard! So let them just close it instead.
		// http://stackoverflow.com/questions/9703271/force-keyboard-open-on-android
		if (screen.keys.pressed(Key.esc) || screen.touch.swiped(Key.left) || screen.touch.swiped(Key.right)) {
			screen.editMode = false
			hiScores.editing = false
			sounds.menuSelect.play
			app().showTitles(true)		
		}

		if (screen.keys.pressed(Key.enter)) {
			if (screen.editMode == true) {
				if (screen.editText.size > 0) {
					screen.editMode = false
					hiScores.editing = false
					hiScores.saveScore(hiScores[newPosition], level)
				}
				
			} else {
				sounds.menuSelect.play
				app().showTitles(true)
			}
		}
		
		
		g2d.drawFont16Centred("Fanny Hi-Scorers", 1 * 16)
		g2d.drawFont16Centred("----------------", 2 * 16)		
		
		g2d.brush = Color.gray
		if (screen.editMode == true) {
			x := ((48 - 22) * 16 / 2) - 2
			y := ((screenPos + 4) * 16) - 1
			w := (22 * 16) + 4
			h := 16 + 2
			if (newPosition == 99) {
				x -= 16
				w += 16
			}
			g2d.fillRoundRect(x, y, w, h, 5, 5)
			g2d.drawFont16Centred("Enter Your Name", 16 * 16)
		} else {
			chars := 19
			x := ((48 - chars) * 16 / 2) - 2
			y := (16 * 16) - 1
			w := (chars * 16) + 4
			h := 16 + 2
			g2d.fillRoundRect(x, y, w, h, 5, 5)			
			g2d.drawFont16Centred("Return to Main Menu", 16 * 16)
		}

		scores.each |hiScore, i| {
			g2d.drawFont16Centred(hiScore.toScreenStr(minPos + i + 1), (i+4) * 16)
		}
	}
}
