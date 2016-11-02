using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afDemo"
		summary = "Be cool..."
		version = Version("0.0.1")

		meta = [
			"proj.name"		: "Demo",
			"repo.private"	: "true",

			"afIoc.module"	: "afDemo::DemoModule"
		]

		depends = [	
			"sys          1.0.69 - 1.0", 
			"gfx          1.0.69 - 1.0",
			"fwt          1.0.69 - 1.0",
			"afIoc        3.0.4  - 3.0",
			
			// ---- Hi-Scores ----
			"concurrent   1.0.69 - 1.0",
			"afConcurrent 1.0.16 - 1.0",
			"afButter     1.2.2  - 1.2",
			"afIocConfig  1.1.0  - 1.1",
		]

		srcDirs = [`fan/`, `fan/gaming/`, `fan/infrastructure/`, `fan/jump/`, `fan/jump/models/`, `fan/sinedots/`]
		resDirs = [`res/`]
	}
}