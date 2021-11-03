extends KinematicBody2D
class_name Bonus

var bonus_life = preload("res://assets/bonus_life.png")
var bonus_balls = preload("res://assets/bonus_balls.png")
var bonus_sticky = preload("res://assets/bonus_sticky.png")

export var speed:float = 100


export(Constants.BonusType) var _bonus_type = Constants.BonusType.Life setget set_bonus_type

onready var _sprite = $Sprite

func set_bonus_type(value):
	_bonus_type = value
	_update_sprite_texture()

func _update_sprite_texture():
	var texture = _get_sprite_texture(_bonus_type)
	if not _sprite == null:
		_sprite.set_texture(texture)
	

func _get_sprite_texture(type:int) -> Texture:
	if type == Constants.BonusType.Life:
		return bonus_life
	if type == Constants.BonusType.Sticky:
		return bonus_sticky
	if type == Constants.BonusType.Balls:
		return bonus_balls
	return bonus_balls


func _ready():
	_update_sprite_texture()

func _physics_process(delta):
	var velocity = Vector2.DOWN * speed
	var collision_info:KinematicCollision2D = move_and_collide(velocity*delta)
	if collision_info == null:
		return
	var collider = collision_info.collider;
	if collider.is_in_group(Constants.group_paddle):
		Events.emit_signal("bonus_picked", _bonus_type)
		queue_free()
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 
	
