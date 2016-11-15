using afIoc
using fwt
using gfx

@Js
class Frame {

	@Inject	private		Screen		screen
	@Inject	private		EventHub	eventHub
	@Inject	private		Pulsar		pulsar
			private		Registry	registry
			internal	Scope?		scope

	new make(Type[] modules, |This|? in := null) {
		registry = RegistryBuilder() { suppressLogging=true }
			.addModule(DemoModule#)
			.addModules(modules)
			.setOption("afIoc.bannerText", "Fanny the Fantom v${typeof.pod.version}")
			.build
		registry.rootScope.createChild("uiThread") { this.scope = it.jailBreak }

		scope.inject(this)

		pulsar.frequency = 1sec / 60 // 60 FPS
		pulsar.addListener |->| { screen.repaint }
	}
	
	Screen widget() {
		screen
	}

	Void startup() {
		eventHub.fireEvent(DemoEvents#onStartup)
		pulsar.start
	}
	
	Void shutdown() {
		pulsar.stop
		eventHub.fireEvent(DemoEvents#onShutdown)
		scope.destroy
		registry.shutdown
	}
}
