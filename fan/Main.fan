using fwt
using gfx
using afIoc

class Main {
	
	static Void main(Str[] args) {
		
		doMain([AppModule#]) |win| {
			// https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
			win.size = Size(512, 288)
//			it.size = Size(640, 360)
			win.title = "Fanny the Fantom"
//			win.icon = Image(`fan://afFish/res/console.png`)
		}

	}	
	
	static Void doMain(Type[] modules, |Window, Scope|? onOpen := null) {
		frame := Frame(modules)
		Window {
			win := it
			it.add(frame.widget)
			it.onOpen.add  |->| { 
				Desktop.callLater(50ms) |->| {
					frame.startup
					onOpen?.call(win, frame.scope)
				}
			}
			it.onClose.add |->| { echo("Bye!") }
		}.open
		frame.shutdown
	}
}
