
@Js
class GameData {
	
	Bool	training			:= false
	Int		level				:= 1
	Float	distSinceLastBlock	:= 0f
	Bool	newBlockPlease		:= true
	
	Float	floorSpeed

	Bool	dying
	Int		deathCryIdx
	
	Int		invisible			//:= 9999999
	Bool	isInvisible() { invisible > 0 }

	Int		score
	Int		blocksJumpedInLevel
	Int		blocksJumpedInGame
	
	Int		cubeBlocks
	
	Bool	cheating
	Bool	godMode
	Bool	rainbowMode
}
