using fwt
using gfx
using afIoc

class Main {
	static const Duration startTime := Duration.now

	static Void logNow(Str msg) {
		echo("$msg - " + (Duration.now - startTime).toLocale)
	}
	
	static Void main(Str[] args) {
		
		// TODO specify offline mode
		
		doMain([AppModule#]) |win| {
//			it.size = Size(640, 360)
			// https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
//			win.size = Size(512, 288)
			win.size = Size(768+8, 288+29)
			win.title = "Fanny the Fantom - Use cursor keys to play"
			win.icon = Image(`fan://afFannyTheFantom/res/fanny-x32.png`)
		}

	}	
	
	static Void doMain(Type[] modules, |Window, Scope|? onOpen := null) {
		frame := Frame(modules)
//		logNow("Made Frame")
		Window {
			win := it
			it.add(frame.widget)
			it.onOpen.add  |->| { 
//				logNow("On open")
				Desktop.callLater(50ms) |->| {
//					logNow("frame start")
					frame.startup
//					logNow("on open")
				}
			}
			it.onClose.add |->| { Main#.pod.log.info("Bye!") }
			onOpen?.call(win, frame.scope)
		}.open
		frame.shutdown
	}
}
