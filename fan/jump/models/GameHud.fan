using gfx

@Js
class GameHud {

	Str?	alertText
	Int		alertIndex

	Void alertGameStart() {
		alertText = "Escape the Mainframe!"
		alertIndex = 120
	}
	
	Void alertTraining(Int level) {
		alertText = "Training Level ${level}"
		alertIndex = 120
	}
	
	Void alertLevelUp() {
		alertText = "Level Up!"
		alertIndex = 120
	}
	
	Void alertGameOver() {
		alertText = "Game Over"
		alertIndex = 160		
	}
	
	Void draw(Gfx g2d, GameData data) {
		g2d.brush = Color.white
		
		scoreStr := "Score " + data.score.toStr.padl(4, '0')
		x := (g2d.bounds.w / 2) - (scoreStr.size * 16)
		y := -g2d.bounds.h / 2
		g2d.drawFont16(scoreStr, x, y)
		
		x = -g2d.bounds.w / 2
		training := data.training ? "Training " : ""
		g2d.drawFont16("${training}Level ${data.level}", x, y)
		
		
		if (alertIndex > 0) {
			alertIndex--
			
			x = -alertText.size * 16 / 2
			y = -3 * 16
			
			g2d.brush = Color.gray
			g2d.fillRoundRect(x - 2, y-1, (alertText.size * 16) + 4, 16 + 2, 5, 5)					
			g2d.drawFont16(alertText, x, y)
		}
	}
}
