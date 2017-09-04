
@Js
class FannySounds : SoundClips {
	
	SoundClip	titleTune() 		{ load("music/titleTune_22khz.wav")			{ it.volume = 1.00f } }

	SoundClip	menuMove() 			{ load("sounds/menuCursor_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	menuSelect() 		{ menuMove							}
	SoundClip	insertCoin() 		{ load("sounds/insertCoin_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	scanned() 			{ load("sounds/scanned_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	startGame() 		{ load("sounds/startGameJingle_22khz.wav")	{ it.volume = 0.125f} }
	SoundClip	jump() 				{ load("sounds/jump_22khz.wav")				{ it.volume = 0.25f } }
	SoundClip	jumpDown() 			{ load("sounds/jumpSquish_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	squish() 			{ load("sounds/crouch_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	squishJump() 		{ load("sounds/superJump_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	bonusCube() 		{ load("sounds/levelUp_22khz.wav")			{ it.volume = 1.00f } }
	SoundClip	levelUp() 			{ load("sounds/bonusCube_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	randomJingle() 		{ load("sounds/randomJingle_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	deathCry() 			{ load("sounds/deathCry_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	gameOver() 			{ load("sounds/gameOver_22khz.wav") 		{ it.volume = 0.18f } }
	SoundClip	winner() 			{ load("sounds/winner_22khz.wav")			{ it.volume = 0.25f } }

	SoundClip	bassMain1() 		{ load("music/bassMain1_22khz.wav")			{ it.volume = 0.50f } }
	SoundClip	bassMain2() 		{ load("music/bassMain2_22khz.wav")			{ it.volume = 0.50f } }
	SoundClip	bassMain3() 		{ load("music/bassMain3_22khz.wav")			{ it.volume = 0.50f } }
	SoundClip	bassExtra1() 		{ load("music/bassExtra1_22khz.wav")		{ it.volume = 0.50f } }
	SoundClip	bassExtra2() 		{ load("music/bassExtra2_22khz.wav")		{ it.volume = 0.50f } }
	SoundClip	fillinHihat() 		{ load("music/fillinHihat_22khz.wav")		{ it.volume = 0.50f } }
	SoundClip	fillinArpeggio1() 	{ load("music/fillinArpeggio1_22khz.wav")	{ it.volume = 0.50f } }
	SoundClip	fillinArpeggio2()	{ load("music/fillinArpeggio2_22khz.wav")	{ it.volume = 0.75f } }
	SoundClip	fillinSquare()		{ load("music/fillinSquareBeeps_22khz.wav")	{ it.volume = 0.50f } }
	SoundClip	melody1()			{ load("music/melody1_22khz.wav")			{ it.volume = 0.50f } }
	SoundClip	melody2()			{ load("music/melody2_22khz.wav")			{ it.volume = 0.50f } }

	SoundClip load(Str name) {
		url := `fan://${typeof.pod}/res/${name}`
		
		// my Win7 really struggles to play the 22 KHz samples, but is fine with 96 Khz!? 
		if (name.startsWith("music") && !name.startsWith("music/titleTune") && Env.cur.runtime != "js") {
			alt := `fan://${typeof.pod}/res/${name[0..<-10]}.wav`
			if (alt.get(null, false) != null)
				url = alt
		}

		return loadSoundClip(url)
	}
	
	SoundClip[] preloadSounds() {
		typeof.methods.findAll |method| {
			(method.returns == SoundClip#) && (method.isPublic) && (!method.isStatic) && (method.params.size == 0)
		}.map |Method method->SoundClip| {
			method.callOn(this, null)
		}
	}
}
