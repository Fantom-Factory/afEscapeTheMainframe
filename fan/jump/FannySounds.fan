
@Js
class FannySounds : SoundClips {
	
	SoundClip	menuMove() 			{ load("menuCursor_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	menuSelect() 		{ menuMove							}
	SoundClip	insertCoin() 		{ load("insertCoin_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	scanned() 			{ load("scanned_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	startGame() 		{ load("startGameJingle_22khz.wav")	{ it.volume = 0.125f} }
	SoundClip	jump() 				{ load("jump_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	jumpDown() 			{ load("jumpSquish_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	squish() 			{ load("crouch_22khz.wav")			{ it.volume = 0.25f } }
	SoundClip	squishJump() 		{ load("superJump_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	bonusCube() 		{ load("levelUp_22khz.wav")			{ it.volume = 1.0f } }
	SoundClip	levelUp() 			{ load("bonusCube_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	randomJingle() 		{ load("randomJingle_22khz.wav")	{ it.volume = 0.25f } }
	SoundClip	deathCry() 			{ load("deathCry_22khz.wav")		{ it.volume = 0.25f } }
	SoundClip	gameOver() 			{ load("gameOver_22khz.wav") 		{ it.volume = 0.18f } }
	SoundClip	winner() 			{ load("winner_22khz.wav")			{ it.volume = 0.25f } }


	
	SoundClip load(Str name) {
		loadSoundClip(`fan://${typeof.pod}/res/sounds/${name}`)
	}
	
	SoundClip[] preloadSounds() {
		typeof.methods.findAll |method| {
			(method.returns == SoundClip#) && (method.isPublic) && (!method.isStatic) && (method.params.size == 0)
		}.map |Method method->SoundClip| {
			method.callOn(this, null)
		}
	}
}
