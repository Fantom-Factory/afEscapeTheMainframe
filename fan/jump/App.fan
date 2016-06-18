using afIoc

class App : DemoEvents {

	@Autobuild	private SineDots	sineDots
	@Autobuild	private GameScreen	gameScreen
	@Autobuild	private TitleScreen	titleScreen
				private GameSeg		activeScreen

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
		
		activeScreen = titleScreen.init
	}

	override Void onDraw(Gfx g) {
//		sineDots.draw(g)
		
		
		activeScreen.draw(g)
	}
	
	Void startGame() {
		activeScreen = gameScreen.init
	}
	
	Void gameOver() {
		activeScreen = titleScreen.init
	}
}

mixin GameSeg {
	abstract This init()
	abstract Void draw(Gfx g2d)
}