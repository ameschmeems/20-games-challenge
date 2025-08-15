extends CanvasLayer

func update_lives_display(lives: int):
	if lives >= 0:
		%Lives.text = "Lives: " + str(lives)
