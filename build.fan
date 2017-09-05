using build
using fanr

class Build : BuildPod {

	new make() {
		podName = "afEscapeTheMainframe"
		summary = "A jump game rendered in stunning retro 3D vector graphics!"
		version = Version("1.0.0")

		meta = [
			"pod.dis"			: "Escape the Mainframe",
			"repo.public"		: "true",
		]

		depends = [	
			"sys          1.0.69 - 1.0", 
			"gfx          1.0.69 - 1.0",
			"fwt          1.0.69 - 1.0",
			"util         1.0.69 - 1.0",

			// ---- Core ----
			"afIoc        3.0.4  - 3.0",
			
			// ---- Online Hi-Scores ----
			"concurrent   1.0.69 - 1.0",
			"dom          1.0.69 - 1.0",
			
			// ---- Web Server ----
			"wisp         1.0.69 - 1.0",
			"web          1.0.69 - 1.0",
			"webmod       1.0.69 - 1.0",
		]

		srcDirs = [`fan/`, `fan/gaming/`, `fan/infrastructure/`, `fan/jump/`, `fan/jump/models/`, `fan/jump/screens/`, `fan/music/`, `fan/sinedots/`, `fan/web/`, `test/`]
		jsDirs	= [`js/`]
		resDirs = [`doc/`, `res/`, `res/images/`, `res/sounds/`, `res/music/`, `res/web/`]
		
        docApi = false
        docSrc = true
        meta["afBuild.docApi"]  = "false"
        meta["afBuild.docSrc"]  = "true"
	}
}
