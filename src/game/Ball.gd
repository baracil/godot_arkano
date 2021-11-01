extends KinematicBody2D
class_name Ball

var glu_to_paddle = true

var _direction = Vector2(0,0)
var velocity = Vector2(0,0)
var speed_factor = 1
export var base_speed = 360 setget set_base_speed,get_base_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_base_speed():
	return base_speed

func set_base_speed(value):
	base_speed = value
	update_velocity()

func size() -> Vector2:
	return $Sprite.get_rect().size

func set_direction(value):
	_direction = value
	update_velocity()

func update_velocity():
	velocity = _direction*speed_factor*base_speed


func _physics_process(delta):
	process_input()
	update_position(delta)

func process_input():
	if (Input.is_action_pressed("ui_launch_ball") and glu_to_paddle):
		glu_to_paddle = false


func update_position(delta):
	if glu_to_paddle:
		return
	var collision_info = move_and_collide(velocity*delta)
	if (collision_info == null):
		return
	#call hit on collider if it exists
	Global.hit(collision_info.collider)

	#todo handle remaining
	var collider = collision_info.collider
	if (collider.is_in_group(Constants.group_paddle)):
		Events.emit_signal("ball_paddle_collided",self,collision_info)

	set_direction(Physics.update_direction_on_collision(_direction,collision_info))
	
	
