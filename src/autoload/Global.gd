extends Node


var _score:int = 0
var _nb_lives:int = 0


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
	

func get_score()->int:
	return _score

func add_to_score(value:int):
	if value == 0:
		return
	_score += value
	Events.emit_signal("score_changed",_score)

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

