extends Node

signal level_done

var _level_area:Polygon2D
var _current_level:Node

func _set_level_area(level_area:Polygon2D):
	_level_area = level_area

func _dispose_current_level():
	if (_current_level == null):
		return
	if (_current_level.has_method("dispose")):
		_current_level.dispose()
	_level_area.remove_child(_current_level)
	_current_level.queue_free()
	_current_level = null




func _set_current_level(level:Node2D):
	_dispose_current_level()
	_current_level = level
	if (_current_level == null):
		return	

	if (_current_level.has_method("initialize")):
		_current_level.initialize(_level_area)

	_current_level.connect("level_done",self,"_on_level_done")	
	_level_area.add_child(_current_level)
	
	
func _on_level_done(level_number:int):
	emit_signal("level_done",level_number)


func load_level(level_number:int):
	var scene_name:String = "res://Levels/Level_%04d.tscn" % level_number
	var level = ResourceLoader.load(scene_name).instance()
	_set_current_level(level)
	

func _ready():
	pass
