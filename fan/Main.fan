using util
using wisp

**
** Fanny the Fantom :: Escape the Mainframe!
** 
class Main : AbstractMain {
	
	@Opt { help = "Start the web server"; aliases = ["web"] }
	Bool webServer:= false

	@Opt { help = "HTTP port of web server" }
	Int port := 8069
	
	@NoDoc
	override Int run() {
		
		if (!webServer) {
			FannyTheFantom().main
			return 0
		}

		if (webServer) {
			wisp := WispService {
				it.httpPort = this.port
				it.root = FannyMod()
			}
			return runServices([wisp])			
		}
		
		usage
		return 1
	}
}