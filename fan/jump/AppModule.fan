using afIoc

const class AppModule {
	
	Void defineServices(RegistryBuilder bob) {
		bob.addService(App#)

		bob.addService(BgGlow#)
		bob.addService(HiScores#)

		// TODO maybe put the qname of this class in pod meta -> for a generic gaming infrastructure
		bob.onScopeCreate("uiThread") |Configuration config| {
			config["eagerLoad"] = |->| {
				config.scope.serviceByType(App#)
			}
		}
	}
}
