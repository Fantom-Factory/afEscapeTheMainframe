using afIoc

@Js
class App : DemoEvents {

	@Inject		private Screen				screen
	@Inject		private HiScores			hiScores
	@Autobuild	private LoadingScreen		loadingScreen
	@Autobuild	private TouchScreen			touchScreen
	@Autobuild	private TitleScreen			titleScreen
	@Autobuild	private IntroScreen			introScreen
	@Autobuild	private GameScreen			gameScreen
	@Autobuild	private OutroScreen			outroScreen
	@Autobuild	private AboutScreen			aboutScreen
	@Autobuild	private HiScoreScreen		hiScoreScreen
	@Autobuild	private HiScoreEntryScreen	hiScoreEntryScreen
	@Autobuild	private CreditsScreen		creditsScreen
				private GameSeg?			activeScreen
				private Bool				loadScoresOnTitleScreen
						Bool				offline
						Bool				offlineMode

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onStartup() {
		activeScreen = loadingScreen.onInit
		hiScores.loadScores
	}
	
	override Void onDraw(Gfx g, Int catchUp) {
		activeScreen?.onDraw(g, catchUp)
	}
	
	Void showTouch() {
		activeScreen = deactivate.touchScreen.onInit
	}
	
	Void showTitles() {
		activeScreen = deactivate.titleScreen.onInit.delay
		if (loadScoresOnTitleScreen)
			hiScores.loadScores
		loadScoresOnTitleScreen = true
	}
	
	Void showIntro(Float fannyY) {
		activeScreen = deactivate.introScreen.onInit.setFannyY(fannyY)
	}
	
	Void startGame(Int? level) {
		activeScreen = deactivate.gameScreen.onInit.trainingLevel(level)
		hiScores.loadScores
	}
	
	Void showAbout() {
		activeScreen = deactivate.aboutScreen.onInit		
	}
	
	Void showHiScores() {
		activeScreen = deactivate.hiScoreScreen.onInit		
	}
	
	Void showCredits() {
		activeScreen = deactivate.creditsScreen.onInit		
	}
	
	Void gameOver(Int score, Int level, Bool cheating, Bool showOutro) {
		deactivate

		if (level == 11 && showOutro) {
			activeScreen = outroScreen.onInit.setMeta(score, level, cheating)
			return
		}
		
		if (!cheating && hiScores.isHiScore(score))
			activeScreen = hiScoreEntryScreen.onInit.setScore(score, level)
		else
			activeScreen = titleScreen.onInit
	}

	private This deactivate() {
		screen.reset
		activeScreen.onKill
		return this
	}
}

@Js
mixin GameSeg {
	abstract This onInit()
	abstract Void onKill()
	abstract Void onDraw(Gfx g2d, Int catchUp)
}
