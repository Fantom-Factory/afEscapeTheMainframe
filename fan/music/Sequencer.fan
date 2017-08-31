using afIoc::Inject

@Js
class Sequencer {
	
	private Sequence[]	sequences	:= Sequence[,]
	
	private Duration	lastBeat	:= Duration.now
	private Int 		count
	public	Bool		play
	internal Int		beatCount
	
	Void playSeq(Sequence seq) {
		this.sequences.add(seq)
	}
	
	Void playNow(Sequence seq) {
		this.sequences.add(seq)
		
		if (count == 0) {
			bc := beatCount - 1
			if (bc < 0)
				bc = 15
			seq.onBeat(bc)
		}
	}
	
	Void onBeat(Int catchUp) {
		if (!play) return

		beat := false
		
		count += catchUp
		if (count >= 24) {
			count = count % 24
			beat = true
		}

//		now := Duration.now
//		if ((now - lastBeat) >= 400ms) {
//			lastBeat = now
//			echo(count)
//			count = count % 24
//			count = 0
//			beat = true
//		}
		

		if (beat) {
//			echo("B = beatCount = $beatCount")
//			echo("B - $sequences")
			sequences = sequences.exclude { it.onBeat(beatCount) }
//			echo("A - $sequences")
		
			beatCount = (beatCount+1) % 16
		}
	}

	Bool has(Sequence seq) {
		sequences.find { seq === it } != null
	}
	
	Void remove(Sequence seq) {
		sequences.removeSame(seq)
	}
	
	Void onPlay() {
		this.play = true
	}

	Void onStop() {
		this.play = false
		sequences.each { it.onStop }
		sequences.clear
	}
}

@Js
class FannySequencer {
	
	@Inject FannySounds	sounds
	@Inject Sequencer 	sequencer
	
	private Sequence titleTune
	private Sequence mainBass
	private Sequence hiHatFillIn
	private Sequence extraBass
	private Sequence arpeggio1
	private Sequence arpeggio2
	private Sequence squareBeeps
	private Sequence melody1
	private Sequence melody2
	
	Sequence[] wannaPlay := Sequence[,]
	
	new make(|This| f) {
		f(this)
		
		titleTune = Sequence("titleTune", Sequent[
			Sequent.play(sounds.titleTune),
			Sequent.pause(71),
			Sequent.loop(0, -1),
		])
		
		mainBass = Sequence("mainBass", Sequent[
			Sequent.even(),
			Sequent.play(sounds.bassMain1),
			Sequent.loop(1, 14),
			Sequent.play(sounds.bassMain2),
			Sequent.play(sounds.bassMain3),
			Sequent.loop(1, -1),
		])
		
		hiHatFillIn = Sequence("hiHatFillIn", Sequent[
			Sequent.even(),
			Sequent.play(sounds.fillinHihat),
			Sequent.loop(1, 6),
		])
	
		extraBass = Sequence("extraBass", Sequent[
			Sequent.even(),
			Sequent.play(sounds.bassExtra1),
			Sequent.play(sounds.bassExtra2),
			Sequent.loop(1, 3),
		])
		
		arpeggio1 = Sequence("arpeggio1", Sequent[
			Sequent.even(),
			Sequent.play(sounds.fillinArpeggio1),
			Sequent.pause(3),
			Sequent.loop(1, 2),
		])
		
		arpeggio2 = Sequence("arpeggio2", Sequent[
			Sequent.even(),
			Sequent.play(sounds.fillinArpeggio2),
			Sequent.pause(15),
		])
		
		melody1 = Sequence("melody1", Sequent[
			Sequent.even(),
			Sequent.play(sounds.melody1),
			Sequent.pause(15),
		])
		
		melody2 = Sequence("melody2", Sequent[
			Sequent.even(),
			Sequent.play(sounds.melody2),
			Sequent.pause(15),
		])

		squareBeeps = Sequence("squareBeeps", Sequent[
			Sequent.even(),
			Sequent.play(sounds.fillinSquare),
			Sequent.pause(7),
			//Sequent.loop(1, 2),
		])
	}
	
	Void playTitleTune() {
		sounds.titleTune.volume = 1.00f
		titleTune.sequents[1].count = 0
		titleTune.index = 0
		sequencer.playNow(titleTune)
	}
	
	Void stopTitleTune() {
		sequencer.remove(titleTune)
		sounds.titleTune.fadeOut(1.5sec)
	}
	
	Void playMainBass() {
		wannaPlay.add(mainBass)
	}

	Void playHiHatFillIn(Int blockScore) {
		if (Int.random.abs % 5 > blockScore) return
		if (sequencer.has(hiHatFillIn))
			hiHatFillIn.sequents[2].count = 0
		else
			wannaPlay.add(hiHatFillIn)
	}
	
	Void playExtraBass(Int blockScore) {
		if (Int.random.abs % 5 > blockScore) return
		if (sequencer.has(extraBass))
			extraBass.sequents[3].count = 0
		else
			wannaPlay.add(extraBass)
	}
	
	Void playArpeggio1(Int level) {
//		if (Int.random.abs % 5 > level) return
		wannaPlay.add(arpeggio1)
	}
	
	Void playWow() {
		beeps := Float.random >= 0.25f
			? [squareBeeps, arpeggio2, melody2]
			: [arpeggio2, squareBeeps, melody2]
		if (!sequencer.has(beeps[0])) {
			wannaPlay.add(beeps[0])
			return
		}
		if (!sequencer.has(beeps[1])) {
			wannaPlay.add(beeps[1])
			return
		}
		if (!sequencer.has(beeps[2])) {
			wannaPlay.add(beeps[2])
			return
		}
	}
	
	Void playMelody() {
		wannaPlay.add(Float.random >= 0.25f ? melody1 : melody2)
	}
	
	Void playBeeps() {
		wannaPlay.add(squareBeeps)
	}
}