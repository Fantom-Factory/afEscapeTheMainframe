using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope

class TitleScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
			private TitleBg?	titleBg
	
	new make(|This| in) { in(this) }

	override This onInit() {
		titleBg = TitleBg()
		return this
	}
	
	override Void onDraw(Gfx g2d) {
		anyKey	:= screen.keys.size > 0

		if (anyKey) {
			app().startGame
		}

		titleBg.draw(g2d)
	}
}
