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
			"sys          1.0.68 - 1.0", 
			"gfx          1.0.68 - 1.0",
			"fwt          1.0.68 - 1.0",
			
			"afIoc        3.0.0  - 3.0",
		]

		srcDirs = [`fan/`, `fan/gaming/`, `fan/infrastructure/`, `fan/jump/`, `fan/jump/models/`, `fan/sinedots/`]
		resDirs = [`res/`]
	}
}