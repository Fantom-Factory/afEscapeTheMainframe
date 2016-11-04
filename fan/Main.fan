using fwt
using gfx
using afIoc

@Js
class Main {

	static Void main(Str[] args) {
		// TODO specify offline mode
		
		doMain([AppModule#]) |win| {
			// see https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
			win.size = Runtime.isJs ? Size(768, 288) : Size(768+8, 288+29)
			win.title = "Fanny the Fantom"
			win.icon = Image(`fan://afFannyTheFantom/res/fanny-x32.png`)
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
					// required, else in JS we have to click in the screen each time it changes!
					win.children.each |w| { w.repaint; w.focus }
				}
			}
			it.onClose.add |->| { Main#.pod.log.info("Bye!") }
			onOpen?.call(win, frame.scope)
		}.open
		
		if (Env.cur.runtime != "js")
			frame.shutdown
	}
}
