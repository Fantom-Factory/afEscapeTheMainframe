
class TestSequencer : Test {

	Sequencer? sequencer
	
	override Void setup() {
		sequencer	= Sequencer()
	}
	
	Void testEven() {
		
		seq := Sequence("testEven", Sequent[
			Sequent.even(),
			Sequent.play(null),
			Sequent.play(null),
		])
		sequencer.onPlay
		verifyEq(seq.index, 0)
		verifyEq(sequencer.beatCount, 0)

		
		// play x1 - goes straight through
		sequencer.playSeq(seq)
		sequencer.onBeat(24)
		verifyEq(seq.index, 2)
		verifyEq(sequencer.has(seq), true)

		sequencer.onBeat(24)
		verifyEq(seq.index, 0)
		verifyEq(sequencer.has(seq), false)
		

		// play x2 - goes straight through
		sequencer.playSeq(seq)
		sequencer.onBeat(24)
		verifyEq(seq.index, 2)
		verifyEq(sequencer.has(seq), true)

		sequencer.onBeat(24)
		verifyEq(seq.index, 0)
		verifyEq(sequencer.has(seq), false)
		

		// off beat
		sequencer.onBeat(24)
		verifyEq(sequencer.beatCount, 5)
		
		// play x2 - pause for 1
		sequencer.playSeq(seq)
		sequencer.onBeat(24)		
		verifyEq(seq.index, 1)
		verifyEq(sequencer.has(seq), true)
		
		sequencer.onBeat(24)		
		verifyEq(seq.index, 2)
		verifyEq(sequencer.has(seq), true)

		sequencer.onBeat(24)
		verifyEq(seq.index, 0)
		verifyEq(sequencer.has(seq), false)
	}
}
