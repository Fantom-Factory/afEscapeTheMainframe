
@Js
class FannySounds : SoundClips {
	
	SoundClip	menuMove() 		{ load("menuMove.wav")		}
	SoundClip	menuSelect() 	{ load("menuSelect.wav")	}


	
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
