using fwt
using gfx

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
	
	static Void doMain(Type[] modules, |Window|? setup := null) {
		frame := Frame(modules)
		Window {			
			it.add(frame.widget)
			it.onOpen.add  |->| { frame.startup }
			it.onClose.add |->| { echo("Bye!") }
			setup?.call(it)
		}.open
		frame.shutdown
	}
}
