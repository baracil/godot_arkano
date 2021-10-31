extends Node


var score:int = 0

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

