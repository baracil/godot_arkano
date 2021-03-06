extends Node2D
class_name Level

var _level_number
var _number_of_bricks := 0

onready var bricks = get_children()

func _on_brick_destroyed(strength, position):
	State.add_to_score(strength)
	_number_of_bricks -= 1
	if (_number_of_bricks == 0):
		Events.emit_signal("level_done",_level_number)

func _init_level(level_number:int):
	_level_number = level_number
	for brick in get_children():
		if brick.is_in_group(Constants.group_brick):
			_number_of_bricks+=1
	
func _ready():
	Events.connect("brick_destroyed",self,"_on_brick_destroyed")
	pass
