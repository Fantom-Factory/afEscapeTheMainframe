
@Js
class Sequence {
	
	Sequent[]	sequents
	Int			index
	Str			name
	
	new make(Str name, Sequent[] sequents) {
		this.name		= name
		this.sequents 	= sequents
	}
	
	** Return 'true' when sequence is finished
	Bool onBeat(Int beat) {
		
		looping := true
		while (looping && index < sequents.size) {
			seq := sequents[index]
			
			if (seq.isEven) {
				if (beat.isOdd)
					looping = false
			}
			
			if (seq.isPause) {
				looping = false
				seq.count++
				if (seq.count >= seq.pauseCount) {
					seq.count = 0
				} else {
					index--
				}
			}

			if (seq.isLoop) {
				seq.count++
				if (seq.count >= seq.loopCount && seq.loopCount != -1) {
					seq.count = 0
				} else {
					index = seq.loopPos - 1
				}
			}

			if (seq.isPlay) {
				seq.soundClip?.stop
				seq.soundClip?.play
				looping = false
			}
			
			index++
		}
		
		if (index >= sequents.size) {
			index = 0
			return true
		}
		
		return false
	}
	
	Sequent seq() {
		sequents[index]
	}
	
	Void onStop() {
		sequents.each { it.soundClip?.stop }
	}
	
	override Str toStr() { "$name @ $index - ${sequents[index]}" }
}

@Js
class Sequent {
	const Str	name
	const Bool 	isPlay
	const Bool 	isLoop
	const Bool 	isEven
	const Bool 	isPause
	
	const Int	loopPos
	const Int	loopCount
	const Int	pauseCount

	SoundClip?	soundClip
	Int			count
	
	new play(SoundClip? soundClip) {
		this.name 		= "play"
		this.isPlay 	= true
		this.soundClip	= soundClip
	}
	new loop(Int pos, Int count) {
		this.name 		= "loop"
		this.isLoop		= true
		this.loopPos	= pos
		this.loopCount	= count
	}
	new even() {
		this.name 		= "even"
		this.isEven		= true
	}
	new pause(Int count) {
		this.name 		= "pause"
		this.isPause	= true
		this.pauseCount = count
	}
	
	override Str toStr() { "$name:$count" }
}