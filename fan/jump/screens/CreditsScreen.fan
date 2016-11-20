using afIoc
using gfx
using fwt

@Js
class CreditsScreen : GameSeg {
	
	@Inject	private Screen			screen
	@Inject	private FannyImages		images
	@Inject	private FannySounds		sounds
	@Inject	private |->App|			app
			private SineDots		sineDots		:= SineDots()
			private CreditsAnim?	creditsAnim

	
	new make(|This| in) {
		in(this)
	}

	override This onInit() {
		creditsAnim = CreditsAnim(images)
		return this
	}
	
	override Void onKill() {
	}

	override Void onDraw(Gfx g2d) {
		anyKey := screen.keys.size > 0 || screen.touch.swiped(Key.enter)
		if (anyKey || creditsAnim.finished) {
			app().showTitles()
		}

		g2d.clear
		sineDots.draw(g2d)
		creditsAnim.draw(g2d)
	}
}

@Js
class CreditsAnim {
	
	private FannyImages	images
	
			Bool		finished

	new make(FannyImages images) {
		this.images = images
		initTweans
	}
	
	Void draw(Gfx g2d) {
		
	}
	
	Void initTweans() {
		
	}
}