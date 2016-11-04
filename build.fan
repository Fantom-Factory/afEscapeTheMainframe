using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afFannyTheFantom"
		summary = "Be cool..."
		version = Version("0.0.1")

		meta = [
			"proj.name"		: "Demo",
			"repo.private"	: "true",

			"afIoc.module"	: "afFannyTheFantom::DemoModule"
		]

		depends = [	
			"sys          1.0.69 - 1.0", 
			"gfx          1.0.69 - 1.0",
			"fwt          1.0.69 - 1.0",
			"afIoc        3.0.4  - 3.0",
			
			// ---- Hi-Scores ----
			"concurrent   1.0.69 - 1.0",
			"afConcurrent 1.0.16 - 1.0",	// FIXME kill me - copy Sync
			"afButter     1.2.2  - 1.2",	// FIXME kill me
			"afIocConfig  1.1.0  - 1.1",	// FIXME kill me
			
			// ---- web ----
			"web          1.0.69 - 1.0",
			"dom          1.0.69 - 1.0",
			"afBedSheet   1.5.4  - 1.5",	// FIXME kill me
			"afDuvet      1.1.2  - 1.1",	// FIXME kill me
		]

		srcDirs = [`fan/`, `fan/gaming/`, `fan/infrastructure/`, `fan/jump/`, `fan/jump/models/`, `fan/jump/screens/`, `fan/sinedots/`, `fan/web/`]
		resDirs = [`res/`]
	}
}