using afIoc
using afBedSheet
using afDuvet

const class WebModule {
	@Contribute { serviceType=Routes# }
	static Void contributeRoutes(Configuration conf) {
		conf.add(Route(`/`, IndexPage#render))
	}
}
