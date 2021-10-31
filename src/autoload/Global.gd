extends Node

signal score_changed

var _score:int = 0

func get_score()->int:
	return _score

func add_to_score(value:int):
	print("Add to score ",value)
	if value == 0:
		return
	_score += value
	emit_signal(Constants.signal_global__score_changed)

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

func _ready():
	pass # Replace with function body.

