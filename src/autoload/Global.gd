extends Node

func initialize(object) -> bool:
	if (object.has_method("initialize")):
		object.initialize()
		return true
	else:
		return false

func dispose(object) -> bool:
	if (object.has_method("dispose")):
		object.dispose()
		return true
	else:
		return false

func hit(hit_object) -> bool:
	if (hit_object.has_method("hit")):
		hit_object.hit()
		return true
	else:
		return false

func switch_to_game():
	Events.emit_signal("game_started")
	get_tree().change_scene(Constants.game_scene_path)

func switch_to_intro():
	get_tree().change_scene(Constants.intro_scene_path)

