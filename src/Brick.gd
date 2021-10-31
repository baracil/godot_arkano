tool
extends StaticBody2D

signal destroyed;

export(int,1,5) var strength := 1 setget set_strength
export(Constants.BrickType) var brick_type = Constants.BrickType.STANDARD setget set_brick_type
export var _health := 1 setget set_health

onready var _polygone2d = $Polygon2D

func set_health(value):
	_health = max(0,min(strength,value))
	_update_color()

func set_strength(value):
	strength = value
	_health = value
	_update_color()

func set_brick_type(value):
	brick_type = value
	_update_color();


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _update_color():
	var color = Constants.get_brick_color(brick_type, strength, _health)
	if not _polygone2d == null:
		_polygone2d.set_color(color)

func _decrease_health():
	_health = max(0,_health-1)
	_update_color()

func is_indestructible():
	return brick_type == Constants.BrickType.INDESCTRUTIBLE

func hit():
	if (_health>0 and not is_indestructible()):
		_decrease_health()
		if (_health <= 0):
			emit_signal(Constants.signal_brick__destroyed,strength)
			queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
#	gradient.add_point(0, color)
#	gradient.add_point(1, Color.gray)
	_health = strength
	_update_color()
	pass