using afIoc

** To see, eager load SineApp in AppModule
@Js
class SineApp : DemoEvents {

	@Autobuild	private SineDots	sineDots

	new make(EventHub eventHub, |This| in) {
		in(this)
		eventHub.register(this)
	}

	override Void onDraw(Gfx g, Int catchUp) {
		g.clear
		sineDots.draw(g, catchUp)
	}
}
