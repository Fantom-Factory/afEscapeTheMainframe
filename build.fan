using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afFannyTheFantom"
		summary = "A jump game rendered in stunning retro 3D vector graphics - Escape the Mainframe!"
		version = Version("0.2.6.2")

		meta = [
			"pod.dis"			: "Fanny the Fantom",
			"pod.displayName"	: "Fanny the Fantom",
			"repo.public"		: "true",
		]

		depends = [	
			"sys          1.0.69 - 1.0", 
			"gfx          1.0.69 - 1.0",
			"fwt          1.0.69 - 1.0",
			"util         1.0.69 - 1.0",

			// ---- Core ----
			"afBeanUtils  1.0.8  - 1.0",
			"afIoc        3.0.4  - 3.0",
			
			// ---- Online Hi-Scores ----
			"concurrent   1.0.69 - 1.0",
			"dom          1.0.69 - 1.0",
			
			// ---- Web Server ----
			"wisp         1.0.69 - 1.0",
			"web          1.0.69 - 1.0",
			"webmod       1.0.69 - 1.0",
		]

		srcDirs = [`fan/`, `fan/gaming/`, `fan/infrastructure/`, `fan/jump/`, `fan/jump/models/`, `fan/jump/screens/`, `fan/sinedots/`, `fan/web/`]
		jsDirs	= [`js/`]
		resDirs = [`doc/`, `res/`, `res/images/`, `res/sounds/`, `res/web/`]
	}
}