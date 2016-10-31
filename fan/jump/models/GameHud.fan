using gfx

class GameHud {

	Void draw(Gfx g2d, GameData data) {
		g2d.brush = Color.white
		
		scoreStr := "Score " + data.score.toStr.padl(5, '0')
		x := (g2d.bounds.w / 2) - (scoreStr.size * 16)
		y := -g2d.bounds.h / 2
		g2d.drawFont16(scoreStr, x, y)
		
		x = -g2d.bounds.w / 2
		g2d.drawFont16("Level ${data.level}", x, y)
	}
}
