using afIoc

** To see, eager load SineApp in AppModule
class SineApp : DemoEvents {

	@Autobuild	private SineDots	sineDots

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onDraw(Gfx g) {
		g.clear
		sineDots.draw(g)
	}
}
