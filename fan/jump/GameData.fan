
@Js
class GameData {
	
	Bool	training			:= false
	Int		level				:= 1
	Float	distSinceLastBlock	:= 0f
	Bool	newBlockPlease		:= true
	
	Float	floorSpeed

	Bool	dying
	Int		deathCryIdx
	
	Int		invincible			//:= true
	Bool	isInvincible() { invincible > 0 }

	Int		score
	Int		blocksJumpedInLevel
	Int		blocksJumpedInGame
	
	Int		cubeBlocks
}
