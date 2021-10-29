extends Node2D


signal level_done

var _level_number
var _number_of_bricks := 0

onready var bricks = get_children()

func _on_brick_destroyed(strength):
	Global.score += strength
	_number_of_bricks -= 1
	print("Brick destroyed ",_number_of_bricks)
	if (_number_of_bricks == 0):
		emit_signal("level_done",_level_number)

func _init_level(level_number:int):
	_level_number = level_number
	for brick in get_children():
		if brick.is_in_group(Global.brick_group):
			_number_of_bricks+=1
			brick.connect("destroyed",self, "_on_brick_destroyed")
	
func _ready():
	pass
