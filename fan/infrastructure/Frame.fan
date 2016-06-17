using afIoc
using fwt
using gfx

class Frame {

	@Inject	private		Screen		screen
	@Inject	private		EventHub	eventHub
			private		Registry	registry
			private		Pulsar		pulsar
			internal	Scope?		scope

	new make(Type[] modules, |This|? in := null) {
		registry = RegistryBuilder() { suppressLogging=true }
			.addModule(DemoModule#)
			.addModules(modules)
			.build
		registry.rootScope.createChildScope("uiThread") { this.scope = it.jailBreak }
		registry.setDefaultScope(scope)
		scope.inject(this)

		pulsar = Pulsar()
		pulsar.frequency = 1sec / 60 // 60 FPS
		pulsar.addListener |->| { screen.repaint }
	}
	
	Widget widget() {
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
