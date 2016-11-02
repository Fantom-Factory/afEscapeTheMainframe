using afIoc
using gfx
using fwt

class HiScoreScreen : GameSeg {
	
	@Inject	private Screen		screen
	@Inject	private |->App|		app
	@Inject	private HiScores	hiScores
	@Inject	private BgGlow		bgGlow
			private Image?		imgScores

			private Int			startScore

			private Int		scoreX
			private Int		speedX
			private Int		scoreTarget
			private Bool	keyLeft
			private Bool	keyRight
	
	
	new make(|This| in) { in(this) }

	override This onInit() {
		imgScores = Image.makePainted(Size(768*10, 160+16)) |g| {
			g2d := screen.gfx(g)
			g2d.clear

			10.times |i| {
				line := ""
				10.times |j| {
					line += hiScores[(j * 10) + i].toScreenStr((j * 10) + i + 1)
				}
				g2d.drawFont16(line, 0, (i * 16)+8)
			}
		}
		return this
	}
	
	override Void onKill() {
	}

	override Void onDraw(Gfx g2d) {
		anyKey	:= screen.keys.dup {
			remove(Key.up)
			remove(Key.down)
			remove(Key.left)
			remove(Key.right)
		}.size > 0
		
		if (anyKey) {
			app().startGame
		}

		if (screen.keys[Key.left] != true)
			keyLeft = false
		
		if (screen.keys[Key.right] != true)
			keyRight = false
		
		if (screen.keys[Key.left] == true && keyLeft == false) {
			keyLeft = true
			if (scoreTarget > 0) {
				speedX = -2
				scoreTarget -= 30
			}
		}

		if (screen.keys[Key.right] == true && keyRight == false) {
			keyRight = true
			if (scoreTarget < (30 * 8)) {
				speedX = 2
				scoreTarget += 30
			}
		}
		
		scoreX += speedX
		if (scoreX == scoreTarget)
			speedX = 0

		x := (scoreX / 30) * 768 / 2f
		r := scoreX % 30
		if (speedX > 0) {
			x += Sin.sin(r / 30f * 0.25f) * 768 / 2
		}
		if (speedX < 0) {
			x -= Sin.sin((r / 30f * 0.25f) + 0.5f) * 768 / 2
		}
		
		bgGlow.draw(g2d)
		g2d.drawFont16Centred("Fanny Hi-Scorers", 1 * 16)
		g2d.drawFont16Centred("----------------", 2 * 16)
		
		g2d.drawImage(imgScores, -x.toInt, (4 * 16)-8) 
		g2d.drawFont16Centred("<<< use cursor keys >>>", 16 * 16) 
	}
}
