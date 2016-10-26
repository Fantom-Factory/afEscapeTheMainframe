
class GameData {
	
	Int		level
	Float	distSinceLastBlock	:= 0f
	Bool	newBlockPlease		:= true
	
	Bool	dying
	Int		deathCryIdx
	
	Bool	invincible			:= true

	Float	floorSpeed() {
		((25f - 8f) * (level / 9f)) + 8f
	}
}
