using afIoc
using gfx

@Js
class LoadingScreen : GameSeg {
	
	@Inject	private |->App|		app
	@Inject	private FannyImages	images
	@Inject	private FannySounds	sounds
	@Inject	private FloorCache	floorCache
	@Inject	private BlockCache	blockCache
			private Int			draws
			private Bool		showPreCalc

	new make(|This| f) { f(this) }
	
	override This onInit() {
		images.preloadImages
		return this
	}
	
	override Void onKill() { }

	override Void onDraw(Gfx g2d) {
		percentImages := preloadImages
		percentSounds := preloadSounds

		if (percentImages >= 100 && percentSounds >= 100 && (!Runtime.isJs || showPreCalc)) {
			floorCache.init
			blockCache.init
			return app().showTitles
		}

		g2d.clear(Color.makeRgb(BgGlow.bgR, BgGlow.bgG, BgGlow.bgB))
		
		drawFont8Centred (g2d, "Alien-Factory",	(16 *  3))
		drawFont8Centred (g2d, "presents",		(16 *  3)+10)
		drawFont16Centred(g2d, "  \"F A N N Y   the   F A N T O M\"",	(16 *  7))
		
		if (percentImages < 100)
			drawFont8Centred(g2d, "loading images - ${percentImages.toStr.justr(3)}%", (16 * 12))
		else {
			if (percentSounds < 100)
				drawFont8Centred(g2d, "loading sounds - ${percentSounds.toStr.justr(3)}%", (16 * 12))
			else {
				drawFont8Centred(g2d, "pre-calculating vectors...", (16 * 12))
				showPreCalc = true
			}
		}

		draws++
	}
	
	private Int preloadImages() {
		images		:= images.preloadImages
		noOfImages	:= images.size
		unloaded	:= images.findAll { it.size == Size.defVal }
		percent		:= ((noOfImages - unloaded.size) * 100) / noOfImages 
		return percent
	}
	
	private Int preloadSounds() {
		sounds		:= sounds.preloadSounds
		noOfSounds	:= sounds.size
		unloaded	:= sounds.findAll { it.loaded.not }
		percent		:= ((noOfSounds - unloaded.size) * 100) / noOfSounds 
		return percent
	}
	
	protected Void drawFont8Centred(Gfx g, Str text, Int y) {
		if (Runtime.isJs && images.font8x8.size == Size.defVal) {
			drawFont8CentredJs(g.g, text, y)
		} else {
			g.drawFont8Centred(text, y)
		}
	}

	protected Void drawFont16Centred(Gfx g, Str text, Int y) {
		if (Runtime.isJs && images.font16x16.size == Size.defVal) {
			drawFont16CentredJs(g.g, text, y)
		} else {
			g.drawFont16Centred(text, y)
		}
	}
	
	private Void drawFont8CentredJs(Graphics g, Str text, Int y) {
		x := (g.clipBounds.w - (text.size * 8)) / 2
		font8 := Font.fromStr("12pt Monospace")
		g.brush = Color.white 
		g.font = font8
		g.drawText(text, x, y)
		font8.dispose
	}	

	private Void drawFont16CentredJs(Graphics g, Str text, Int y) {
		x := (g.clipBounds.w - (text.size * 16)) / 2
		font16 := Font.fromStr("24pt Monospace")
		g.brush = Color.white 
		g.font = font16
		g.drawText(text, x, y)
		font16.dispose
	}	
}
