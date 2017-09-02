using [java] fanx.interop::Interop
using [java] javax.sound.sampled::AudioSystem
using [java] javax.sound.sampled::AudioFormat
using [java] javax.sound.sampled::Clip
using [java] javax.sound.sampled::DataLine$Info as Info
using [java] javax.sound.sampled::FloatControl
using [java] javax.sound.sampled::FloatControl$Type as FType
using concurrent

@Js
class SoundClips {
	private const Log		log			:= typeof.pod.log
	private Str:SoundClip	soundClips	:= Str:SoundClip[:]

	Bool mute {
		set {
			&mute = it
			if (it) stopAll
		}
	}
	
	Void stopAll() {
		soundClips.each |soundClip| {
			soundClip.stop
		}
	}
	
	SoundClip loadSoundClip(Uri soundUrl) {
		soundClips.getOrAdd(soundUrl.toStr) |->SoundClip| {
			log.debug("Loading Sound ${soundUrl.name}")
			urlHook := (|Uri->Uri|?) Actor.locals["skySpark.urlHook"] ?: |Uri uri->Uri| { uri }
			return Env.cur.runtime == "js"
				? typeof.pod.type("SoundClipJs"  ).make([urlHook(soundUrl), this])
				: typeof.pod.type("SoundClipJava").make([urlHook(soundUrl), this])
		}
	}
}

@Js
mixin SoundClip {
	abstract Float volume
	abstract Bool loaded()
	abstract Void play()
	abstract Void stop()
	abstract Void fadeOut(Duration duration)
}

class SoundClipJava : SoundClip {
	private Uri			soundUri
	private Clip		clip
	private SoundClips	soundClips
	
	new make(Uri soundUri, SoundClips soundClips) {
		soundFile			:= soundUri.get as File
		soundStream 		:= Interop.toJava(soundFile.in)
	    audioInputStream	:= AudioSystem.getAudioInputStream(soundStream)
   	 	audioFormat			:= audioInputStream.getFormat
    	dataLineInfo		:= Info(Clip#->toClass, audioFormat)
        clip 				:= AudioSystem.getLine(dataLineInfo) as Clip
        clip.open(audioInputStream)
		
		this.clip		= clip
		this.soundUri	= soundUri
		this.soundClips	= soundClips
	}
	
	// see http://stackoverflow.com/questions/40514910/set-volume-of-java-clip/40698149#40698149
	override Float volume {
		get {
			gainControl	:= (FloatControl) clip.getControl(FType.MASTER_GAIN)
			return 10f.pow(gainControl.getValue / 20f)
		}
		set {
			if (it < 0f || it > 1f)
				throw ArgErr("Invalid volume: $it")
			gainControl	:= (FloatControl) clip.getControl(FType.MASTER_GAIN)
			gainControl.setValue(20f * it.log10)
		}
	}
	
	override Bool loaded() { true }
	
	override Void play() {
		if (soundClips.mute) return

		stop
		clip.setFramePosition(0)
		clip.start
	}
	
	override Void stop() {
		if (clip.isRunning) {
			clip.stop
			clip.flush
			clip.drain
		}
	}
	
	override Void fadeOut(Duration duration) {
		thisRef := Unsafe(this)
		Actor(ActorPool()) |->| {
			that := (SoundClipJava) thisRef.val
			try {
				vol  := that.volume
				incs := vol / (duration.toMillis / 50)
				gain := (FloatControl) that.clip.getControl(FType.MASTER_GAIN)
				time := Duration.now + duration
				while (Duration.now < time) {
					vol = (vol - incs).max(0.01f)
					gain.setValue(20f * vol.log10)
					Actor.sleep(50ms)
				}
			} catch (Err err)
				err.trace
			that.stop
		}.send(null)
	}
	
	override Str toStr() {
		soundUri.name
	}
}

@Js
native class SoundClipJs : SoundClip {
	
	override Float volume
	
	new make(Uri soundUrl, SoundClips soundClips)
	
	override Bool loaded()

	override Void play()
	override Void stop()
	
	override Void fadeOut(Duration duration)
}
