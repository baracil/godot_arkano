extends StaticBody2D
class_name Playground

onready var _levelArea = $LevelArea

var _bonuses = Array()


func pop_bonus(bonus_type, position_in_level_area:Vector2):
	var bonus:Bonus = ResourceLoader.load(Constants.bonus_scene_path).instance()
	bonus.set_bonus_type(bonus_type)
	bonus.position = position_in_level_area + _levelArea.transform.get_origin()
	_bonuses.append(bonus)
	self.call_deferred("add_child", bonus)
	
func clear_bonus():
	for bonus in _bonuses:
		if is_instance_valid(bonus):
			bonus.queue_free()
	_bonuses.clear()

