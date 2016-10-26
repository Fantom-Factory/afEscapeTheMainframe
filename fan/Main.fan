using fwt
using gfx
using afIoc

class Main {
	static const Duration startTime := Duration.now

	static Void logNow(Str msg) {
		echo("$msg - " + (Duration.now - startTime).toLocale)
	}
	
	static Void main(Str[] args) {
		
		doMain([AppModule#]) |win| {
			// https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
			win.size = Size(512, 288)
			win.size = Size(768, 288)
//			it.size = Size(640, 360)
			win.title = "Fanny the Fantom"
			win.icon = Image(`fan://afDemo/res/fanny-x32.png`)
		}

	}	
	
	static Void doMain(Type[] modules, |Window, Scope|? onOpen := null) {
		frame := Frame(modules)
		logNow("Made Frame")
		Window {
			win := it
			it.add(frame.widget)
			it.onOpen.add  |->| { 
				logNow("On open")
				Desktop.callLater(50ms) |->| {
					logNow("frame start")
					frame.startup
					logNow("on open")
					onOpen?.call(win, frame.scope)
				}
			}
			it.onClose.add |->| { echo("Bye!") }
		}.open
		frame.shutdown
	}
}
