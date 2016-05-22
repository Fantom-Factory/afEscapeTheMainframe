using fwt
using gfx

class Main {
	
	static Void main(Str[] args) {
		
		demdow := Demdow()
		Window {
			win  := it
			it.size = Size(640, 480)
			it.size = Size(320, 240)
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
