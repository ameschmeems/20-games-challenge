extends CanvasLayer

func update_score_display(score: int):
	%Score.text = str(score)

func update_lives_display(lives: int):
	if lives >= 0:
		%Lives.text = "Lives: " + str(lives)

func update_high_score_display(score: int):
	%HighScore.text = "High score: " + str(score)