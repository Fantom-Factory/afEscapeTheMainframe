using afIoc

const class AppModule {
	
	Void defineServices(RegistryBuilder bob) {
		bob.addService(App#)

		bob.addService(SinOld#)
		
		// TODO maybe put the qname of this class in pod meta
		bob.onScopeCreate("uiThread") |Configuration config| {
			config["eagerLoad"] = |->| {
				config.scope.serviceByType(App#)
			}
		}
	}
}
