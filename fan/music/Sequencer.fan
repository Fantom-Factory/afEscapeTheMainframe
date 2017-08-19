using afIoc::Inject

@Js
class Sequencer {
	
	private Sequence[]	sequences	:= Sequence[,]
	
	private Duration	lastBeat	:= Duration.now
	private Int 		count
	private Bool		play
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
			echo(count)
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
		sequences.indexSame(seq) != null
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
	
	private Sequence mainBass
	private Sequence hiHatFillIn
	private Sequence extraBass
	private Sequence arpeggio1
	private Sequence arpeggio2
	
	Sequence[] wannaPlay := Sequence[,]
	
	new make(|This| f) {
		f(this)
		
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
			Sequent.loop(1, 4),
		])
	
		extraBass = Sequence("extraBass", Sequent[
			Sequent.even(),
			Sequent.play(sounds.bassExtra1),
			Sequent.play(sounds.bassExtra2),
			Sequent.loop(1, 2),
		])
		
		arpeggio1 = Sequence("arpeggio1", Sequent[
			Sequent.even(),
			Sequent.play(sounds.fillinArpeggio),
			Sequent.pause(3),
		])
		
		arpeggio2 = Sequence("arpeggio2", Sequent[
			Sequent.even(),
			Sequent.play(sounds.tuneArpeggio),
			Sequent.pause(15),
		])
		
		mainBass = extraBass
	}
	
	Void playMainBass() {
		wannaPlay.add(mainBass)
//		if (!sequencer.has(mainBass))
//			sequencer.playSeq(mainBass)
	}

	Void playHiHatFillIn() {
		wannaPlay.add(hiHatFillIn)
//		if (!sequencer.has(hiHatFillIn))
//			sequencer.playSeq(hiHatFillIn)
	}
	
	Void playExtraBass() {
		wannaPlay.add(extraBass)
//		if (!sequencer.has(extraBass))
//			sequencer.playSeq(extraBass)
	}
	
	Void playArpeggio1() {
		wannaPlay.add(arpeggio1)
//		if (!sequencer.has(arpeggio1))
//			sequencer.playSeq(arpeggio1)
	}
	
	Void playArpeggio2() {
		wannaPlay.add(arpeggio2)
//		if (!sequencer.has(arpeggio2))
//			sequencer.playSeq(arpeggio2)
	}
	
}