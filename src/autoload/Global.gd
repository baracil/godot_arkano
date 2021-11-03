extends Node


func _has_method(object, method:String) -> bool:
	return is_instance_valid(object) and object.has_method(method)

func initialize(object):
	if _has_method(object,"initialize"):
		object.initialize()

func dispose(object):
	if _has_method(object,"dispose"):
		object.dispose()

func hit(object):
	if _has_method(object,"hit"):
		object.hit()

func switch_to_game():
	Events.emit_signal("game_started")
	get_tree().change_scene(Constants.game_scene_path)

func switch_to_intro():
	get_tree().change_scene(Constants.intro_scene_path)

