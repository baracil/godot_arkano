extends Node


var _level_area:Polygon2D
var _current_level:Node

func _set_level_area(level_area:Polygon2D):
	_level_area = level_area

func _dispose_current_level():
	if not is_instance_valid(_current_level):
		return
	Global.dispose(_current_level)
	_level_area.remove_child(_current_level)
	_current_level.queue_free()
	_current_level = null


func _set_current_level(level:Node2D):
	_dispose_current_level()
	_current_level = level
	if (_current_level == null):
		return	
	Global.initialize(_current_level)
	_level_area.add_child(_current_level)


func load_level(level_number:int):
	var scene_name:String = Constants.level_scene_path(level_number)
	var level = ResourceLoader.load(scene_name).instance()
	_set_current_level(level)
	State.set_level_number(level_number)
	
func clear_level():
	_dispose_current_level()
	State.set_level_number(0)
	

func _ready():
	pass
