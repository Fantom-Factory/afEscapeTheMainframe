using afIoc
using afIocConfig
using afConcurrent
using concurrent

@Js
@SubModule { modules=[IocConfigModule#] }
const class AppModule {

	Void defineServices(RegistryBuilder bob) {
		bob.addService(App#)

		bob.addService(BgGlow#)
		bob.addService(HiScores#)
		bob.addService(FannyImages#)

		// TODO maybe put the qname of this class in pod meta -> for a generic gaming infrastructure
		bob.onScopeCreate("uiThread") |Configuration config| {
			config["eagerLoad"] = |->| {
				config.scope.serviceByType(App#)

//				config.build(SineApp#)
			}
		}
	}
	
	@Build
	HiScoreOnline buildHiScoreOnline(Scope scope) {
		// use reflection to avoid Js warnings
		Runtime.isJs ? scope.build(HiScoreOnlineJs#) : scope.build(typeof.pod.type("HiScoreOnlineJava"))
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	Void contributeFactoryDefaults(Configuration config) {
//		config["hiScores.apiUrl"] = `http://hiscores.fantomfactory.org/`
		config["hiScores.apiUrl"] = `http://localhost:8080/`
	}
}
