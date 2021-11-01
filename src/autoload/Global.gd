extends Node

signal score_changed
signal player_died
signal nb_lives_changed

var _score:int = 0
var _nb_lives:int = 3


func get_nb_lives()->int:
	return _nb_lives

func remove_one_life():
	_update_nb_lives(false)

func add_one_life():
	_update_nb_lives(true)
	

func _update_nb_lives(increase:bool):
	if _nb_lives<=0:
		return
	if increase:
		_nb_lives += 1
	else:
		_nb_lives -= 1
	emit_signal(Constants.signal_global__nb_lives_changed)
	if _nb_lives<=0:
		emit_signal(Constants.signal_global__player_died)
	

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

