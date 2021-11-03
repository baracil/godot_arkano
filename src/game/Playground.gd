extends StaticBody2D
class_name Playground

onready var _levelArea = $LevelArea


func pop_bonus(bonus_type, position_in_level_area:Vector2):
	var bonus:Bonus = ResourceLoader.load(Constants.bonus_scene_path).instance()
	bonus.set_bonus_type(bonus_type)
	bonus.position = position_in_level_area + _levelArea.transform.get_origin()
	self.call_deferred("add_child", bonus)
	

