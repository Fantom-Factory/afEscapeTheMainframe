using afIoc

class App : DemoEvents {

	@Autobuild	private SineDots	sineDots
	@Autobuild	private GameScreen	game

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onDraw(Gfx g) {
//		sineDots.draw(g)
		
		
		game.draw(g)
	}
}
