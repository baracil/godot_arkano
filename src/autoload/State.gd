extends Node


var _score:int = 0
var _nb_lives:int = 0
var _level_number:int = 0
var _use_mouse:bool = false

func get_use_mouse() -> bool:
	return _use_mouse
	
func set_use_mouse(use_mouse:bool):
	_use_mouse = use_mouse
	print(_use_mouse)
	Events.emit_signal("use_mouse_changed",_use_mouse)
	
func toggle_use_mouse():
	set_use_mouse(!_use_mouse)

func get_nb_lives()->int:
	return _nb_lives

func remove_one_life():
	_update_nb_lives(false)

func add_one_life():
	_update_nb_lives(true)
	
func set_nb_lives(nb_lives):
	_nb_lives = nb_lives
	Events.emit_signal("nb_lives_changed",nb_lives)
	

func _update_nb_lives(increase:bool):
	if _nb_lives<=0:
		return
	if increase:
		_nb_lives += 1
	else:
		_nb_lives -= 1
	_nb_lives = max(0,_nb_lives)
	Events.emit_signal("nb_lives_changed",_nb_lives)
	if _nb_lives<=0:
		Events.emit_signal("player_died")
	

func set_score(score:int):
	_score = score 
	Events.emit_signal("score_changed",_score)

func get_score()->int:
	return _score

func add_to_score(value:int):
	set_score(_score+value)


func set_level_number(level_number:int):
	if (_level_number == level_number):
		return
	_level_number = level_number
	Events.emit_signal("level_number_changed",level_number)

func get_level_number() -> int:
	return _level_number
