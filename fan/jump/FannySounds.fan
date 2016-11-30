
@Js
class FannySounds : SoundClips {
	
	SoundClip	menuMove() 			{ load("menuCursor_22khz.wav")		}
	SoundClip	menuSelect() 		{ menuMove							}
	SoundClip	insertCoin() 		{ load("insertCoin_22khz.wav")		}
	SoundClip	scanned() 			{ load("scanned_22khz.wav")			}
	SoundClip	startGame() 		{ load("startGameJingle_22khz.wav")	{ it.volume = 0.5f }  }
	SoundClip	jump() 				{ load("jump_22khz.wav")			}
	SoundClip	jumpSquish() 		{ load("jumpSquish_22khz.wav")		}
	SoundClip	squish() 			{ load("crouch_22khz.wav")			}
	SoundClip	bonusCube() 		{ load("levelUp_22khz.wav")			}
	SoundClip	levelUp() 			{ load("bonusCube_22khz.wav")		}
	SoundClip	randomJingle() 		{ load("randomJingle_22khz.wav")	}
	SoundClip	deathCry() 			{ load("deathCry_22khz.wav")		}
	SoundClip	gameOver() 			{ load("gameOver_22khz.wav") { it.volume = 0.6f }		}
	SoundClip	winner() 			{ load("winner_22khz.wav")			}


	
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
