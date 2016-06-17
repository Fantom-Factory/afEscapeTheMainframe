using afIoc

class App : DemoEvents {

	@Autobuild	private SineDots	sineDots
	@Autobuild	private GameScreen	gameScreen
	@Autobuild	private TitleScreen	titleScreen
				private Obj			activeScreen

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
		
		activeScreen = titleScreen
	}

	override Void onDraw(Gfx g) {
//		sineDots.draw(g)
		
		
		activeScreen->draw(g)
	}
	
	Void startGame() {
		activeScreen = gameScreen
	}
	
	Void gameOver() {
		activeScreen = titleScreen		
	}
}
