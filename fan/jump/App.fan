using afIoc

class App : DemoEvents {

	@Inject		private Screen			screen
//	@Autobuild	private SineDots		sineDots
	@Autobuild	private GameScreen		gameScreen
	@Autobuild	private TitleScreen		titleScreen
	@Autobuild	private HiScoreScreen	hiScoreScreen
				private GameSeg?		activeScreen
						Bool			offline

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onStartup() {
		activeScreen = titleScreen.onInit.delay
	}
	
	override Void onDraw(Gfx g) {
//		sineDots.draw(g)
		activeScreen?.onDraw(g)
	}
	
	Void startGame() {
		screen.keys.clear
		activeScreen.onKill
		activeScreen = gameScreen.onInit
	}
	
	Void showTitles() {
		screen.keys.clear
		activeScreen.onKill
		activeScreen = titleScreen.onInit		
	}
	
	Void showHiScores() {
		screen.keys.clear
		activeScreen.onKill
		activeScreen = hiScoreScreen.onInit		
	}
	
	Void gameOver() {
		screen.keys.clear
		activeScreen.onKill
		activeScreen = titleScreen.onInit
	}
}

mixin GameSeg {
	abstract This onInit()
	abstract Void onKill()
	abstract Void onDraw(Gfx g2d)
}