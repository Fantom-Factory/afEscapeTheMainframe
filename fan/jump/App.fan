using afIoc

class App : DemoEvents {

	@Inject		private Screen		screen
//	@Autobuild	private SineDots	sineDots
	@Autobuild	private GameScreen	gameScreen
	@Autobuild	private TitleScreen	titleScreen
				private GameSeg		activeScreen

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
		
		activeScreen = titleScreen.onInit
	}

	override Void onDraw(Gfx g) {
//		sineDots.draw(g)
		activeScreen.onDraw(g)
	}
	
	Void startGame() {
		screen.keys.clear
		activeScreen = gameScreen.onInit
	}
	
	Void gameOver() {
		screen.keys.clear
		activeScreen = titleScreen.onInit
	}
}

mixin GameSeg {
	abstract This onInit()
	abstract Void onDraw(Gfx g2d)
}