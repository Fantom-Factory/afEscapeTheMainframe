using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope
using concurrent::Actor

class TitleScreen : GameSeg {

	@Inject	private Screen		screen
	@Inject	private |->App|		app
			private TitleBg?	titleBg
	
	new make(|This| in) { in(this) }

	override This onInit() {
		titleBg = TitleBg()
		titleBg.bgIndex = Actor.locals["afFanny.bgIndex"] ?: 0.5f
		titleBg.bgHexX  = Actor.locals["afFanny.bgHexX" ] ?: 0f
		return this
	}
	
	override Void onKill() {
		Actor.locals["afFanny.bgIndex"] = titleBg.bgIndex
		Actor.locals["afFanny.bgHexX" ] = titleBg.bgHexX
	}

	override Void onDraw(Gfx g2d) {
		anyKey	:= screen.keys.size > 0

		if (anyKey) {
			app().startGame
		}

		titleBg.draw(g2d)
	}
}
