using fwt
using gfx

class Main {
	
	static Void main(Str[] args) {
		
		demdow := Demdow()
		Window {
			win  := it
			// https://pacoup.com/2011/06/12/list-of-true-169-resolutions/
			it.size = Size(512, 288)
//			it.size = Size(640, 360)
			it.title = "Demo"
//			it.icon = Image(`fan://afFish/res/console.png`)
			it.add(demdow.widget)
			it.onOpen.add |->| {
				demdow.startup
			}
			it.onClose.add |->| {
				echo("Bye!")
			}
		}.open

		demdow.shutdown
	}
}
