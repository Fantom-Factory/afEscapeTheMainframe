using fwt::Key
using gfx::Color
using afIoc::Inject
using afIoc::Scope

class TitleScreen {

	@Inject	private Scope	scope
	@Inject	private Screen	screen
	@Inject	private |->App|	app
	
	new make(|This| in) {
		in(this)		
	}

	Void draw(Gfx g2d) {
		anyKey	:= screen.keys.size > 0

		if (anyKey) {
			echo(scope.registry.activeScope)
			app().startGame
		}

		g2d.clear
		g2d.drawFont8Centred("Fanny the Fantom", 50)
	}
}
