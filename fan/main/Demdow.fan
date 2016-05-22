using afIoc
using fwt
using gfx

class Demdow : DemoEvents {

	@Inject	private Screen		screen
	@Inject	private EventHub	eventHub
			private Registry	registry
			private Scope		scope
			private Pulsar		pulsar

	new make(|This|? f := null) {
		f?.call(this)
		
		registry	= RegistryBuilder() { suppressLogging=true }
			.addModule(DemoModule#)
//			.addModulesFromPod("afPlastic")
//			.addModulesFromPod("afConcurrent")
//			.addModulesFromPod("afIocConfig")
			.build
		registry.rootScope.createChildScope("thread") { this.scope = it.jailBreak }
		scope.inject(this)

		pulsar = Pulsar()
		pulsar.frequency = 40ms
		pulsar.addListener |->| { screen.repaint }
		
		eventHub.register(this)
	}
	
	Widget widget() {
		screen
	}

	Void startup() {
		pulsar.start
	}
	
	Void shutdown() {
		pulsar.stop
		scope.destroy
		registry.shutdown
	}
	
	@Inject	private SineDots sineDots

	override Void draw(Gfx g) {
		sineDots.draw(g)
	}
}
