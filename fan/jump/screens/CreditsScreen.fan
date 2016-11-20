using afIoc
using gfx
using fwt

@Js
class CreditsScreen : GameSeg {
	
	@Inject	private Screen			screen
	@Inject	private FannyImages		images
	@Inject	private FannySounds		sounds
	@Inject	private |->App|			app
			private SineDots		sineDots		:= SineDots()
			private CreditsAnim?	creditsAnim

	
	new make(|This| in) {
		in(this)
	}

	override This onInit() {
		creditsAnim = CreditsAnim(images)
		return this
	}
	
	override Void onKill() {
	}

	override Void onDraw(Gfx g2d) {
		anyKey := screen.keys.size > 0 || screen.touch.swiped(Key.enter)
		if (anyKey || creditsAnim.finished) {
			app().showTitles()
		}

		g2d.clear
		sineDots.draw(g2d)
		creditsAnim.draw(g2d)
	}
}

@Js
class CreditsAnim {
	
	private FannyImages	images
			Int			time	:= 1
	
	private	CreditTwean[]	credits	:= CreditTwean[,]
	
			Bool		finished

	new make(FannyImages images) {
		this.images = images
		initTweans
	}
	
	Void draw(Gfx g2d) {
		credits.each { it.draw(g2d, time) }
		time++
	}
	
	Void initTweans() {
		credits = [
			CreditTwean {
				it.title		= "Alien-Factory presents"
				it.name			= "FANNY the FANTOM"
				it.startFrame	= 100
			},
			CreditTwean {
				it.title		= "Coding & Game Design"
				it.name			= "Steve Eynon"
				it.startFrame	= 300
			},
			CreditTwean {
				it.title		= "Sound Effects"
				it.name			= "Modulate"
				it.startFrame	= 500
			},
			CreditTwean {
				it.title		= "Cartoon Graphics"
				it.name			= "Ajordaz"
				it.startFrame	= 700
			},
		]
	}
}

@Js
class CreditTwean : Twean {
	const Int		animSpeed	:= 15

	Str		name
	Str		title
	Bool	finished
	
	new make(|This| f) : super(f) {
		startX = -width
		finalX = (FannyTheFantom.windowSize.w * 3 / 5) - width
		startY = finalY = 7 * 16
		endFrame = startFrame + animSpeed
	}

	Int width() {
		(title.size * 8).max(name.size * 16) + 32
	}
	
	override Void draw(Gfx g2d, Int time) {
		if ((time <= startFrame && easeIn) || finished)
			return

		startF	:= startFrame
		endF	:= endFrame
		if (!easeIn) {
			startF	+= 6
			endF	+= 6
		}
		if ((easeIn && time > startF) || (!easeIn && time < endF)) {
			ratio := easeIn ? 1f : 0f
			if (time >= startF && time <= endF)
				ratio = this.ratio(time, easeIn, startF, endF)
			x := ((finalX - startX) * ratio) + startX
			x += (width - (title.size * 8)) / 2
			g2d.drawFont8(title, x.toInt, finalY)
		}

		startF	= startFrame	+ 3
		endF	= endFrame		+ 3
		if ((easeIn && time > startF) || (!easeIn && time < endF)) {
			ratio := easeIn ? 1f : 0f
			if (time >= startF && time <= endF)
				ratio = this.ratio(time, easeIn, startF, endF)
			x1 := ((finalX - startX) * ratio) + startX
			x2 := x1 + width
			g2d.brush = Models.brand_lightBlue
			g2d.drawLine(x1.toInt, finalY + 10, x2.toInt, finalY + 10)
		}
		
		startF	= startFrame
		endF	= endFrame
		if (easeIn) {
			startF	+= 6
			endF	+= 6
		}
		if ((easeIn && time > startF) || (!easeIn && time < endF)) {
			ratio := easeIn ? 1f : 0f
			if (time >= startF && time <= endF)
				ratio = this.ratio(time, easeIn, startF, endF)
			x := ((finalX - startX) * ratio) + startX
			x += (width - (name.size * 16)) / 2 
			g2d.drawFont16(name, x.toInt, finalY + 13)
		}
		
		if (easeIn)
			finalX += 1
		else
			startX += 1

		if (easeIn && finalX > ((FannyTheFantom.windowSize.w * 4 / 5) - width)) {
			easeIn = false
			startX = finalX
			finalX = FannyTheFantom.windowSize.w
			
			startFrame	= time
			endFrame	= time + animSpeed
		}
		
		if (!easeIn && time >= (endFrame+10)) {
			finished = true
			echo(time)
		}
	}
}