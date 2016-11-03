using afIoc

class App : DemoEvents {

	@Inject		private Screen				screen
	@Inject		private HiScores			hiScores
	@Autobuild	private TitleScreen			titleScreen
	@Autobuild	private GameScreen			gameScreen
	@Autobuild	private AboutScreen			aboutScreen
	@Autobuild	private HiScoreScreen		hiScoreScreen
	@Autobuild	private HiScoreEnterScreen	hiScoreEnterScreen
				private GameSeg?			activeScreen
						Bool				offline
						Bool				offlineMode

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onStartup() {
		activeScreen = titleScreen.onInit.delay
		hiScores.loadScores
	}
	
	override Void onDraw(Gfx g) {
		activeScreen?.onDraw(g)
	}
	
	Void startGame(Int? level) {
//		gameOver(1095)
		activeScreen = deactivate.gameScreen.onInit.trainingLevel(level)
		hiScores.loadScores
	}
	
	Void showTitles() {
		activeScreen = deactivate.titleScreen.onInit		
	}
	
	Void showAbout() {
		activeScreen = deactivate.aboutScreen.onInit		
	}
	
	Void showHiScores() {
		activeScreen = deactivate.hiScoreScreen.onInit		
	}
	
	Void gameOver(Int score, Bool training) {
		deactivate
	
		if (!training && hiScores.isHiScore(score))
			activeScreen = hiScoreEnterScreen.onInit.setScore(score)
		else
			activeScreen = titleScreen.onInit
	}

	private This deactivate() {
		screen.keys.clear
		activeScreen.onKill
		return this
	}
}

mixin GameSeg {
	abstract This onInit()
	abstract Void onKill()
	abstract Void onDraw(Gfx g2d)
}