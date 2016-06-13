using afIoc

const class DemoModule {

	Void defineServices(RegistryBuilder bob) {
		bob.addScope("thread", true)
		
		bob.addService(Sin#)
		bob.addService(SinOld#)
		bob.addService(Screen#)
		
		bob.addService(SineDots#)

		bob.addService(EventHub#)
		bob.addService(EventTypes#)
	}
	
	@Contribute { serviceType=EventTypes# }
	Void contributeEventTypes(Configuration config) {
		config.add(DemoEvents#)
	}

	Void onRegistryStartup(Configuration config) {
		config.remove("afIoc.logServices")
		config.remove("afIoc.logBanner")
		config.remove("afIoc.logStartupTimes")
	}

	Void onRegistryShutdown(Configuration config) {
		config.remove("afIoc.sayGoodbye")
	}
}
