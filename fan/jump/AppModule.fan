using afIoc
using afIocConfig
using afConcurrent
using concurrent

@SubModule { modules=[IocConfigModule#, ConcurrentModule#] }
const class AppModule {

	Void defineServices(RegistryBuilder bob) {
		bob.addService(App#)

		bob.addService(BgGlow#)
		bob.addService(HiScores#)

		// TODO maybe put the qname of this class in pod meta -> for a generic gaming infrastructure
		bob.onScopeCreate("uiThread") |Configuration config| {
			config["eagerLoad"] = |->| {
				config.scope.serviceByType(App#)

//				config.build(SineApp#)
			}
		}
	}
	
	@Contribute { serviceType=ActorPools# }
	Void contributeActorPools(Configuration config) {
		config["hiScores"] = ActorPool() { it.name = "Hi-Scores" }
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	Void contributeFactoryDefaults(Configuration config) {
		config["hiScores.apiUrl"] = `http://hiscores.fantomfactory.org/`
	}
}
