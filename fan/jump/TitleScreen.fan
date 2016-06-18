using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope

class TitleScreen : GameSeg {

	@Inject	private Screen	screen
	@Inject	private |->App|	app
	
	new make(|This| in) { in(this) }

	override This init() {
		return this
	}
	
	override Void draw(Gfx g2d) {
		anyKey	:= screen.keys.size > 0

		if (anyKey) {
			app().startGame
		}

		g2d.clear
		g2d.drawFont8Centred("Fanny the Fantom", 50)
	}
}
