extends Panel


func _ready():
	pass


func _on_Quit_pressed():
	get_tree().quit()


func _on_NewGame_pressed():
	Global.switch_to_game()
