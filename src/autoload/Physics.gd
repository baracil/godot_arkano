extends Node

export var min_angle:=5 setget set_min_angle
var min_angle_in_rad:=5.0*PI/180

const x := Vector2(1,0)
const y := Vector2(0,-1)

func set_min_angle(value):
	min_angle = value
	min_angle_in_rad = deg2rad(value)

## Update the provided direction to simulate a bounce on a wall.
##  direction: the direction to update
##  normal : the normal of the collision
##
func _update_direction_on_collision_on_bounce(
	direction:Vector2,
	normal:Vector2
	)-> Vector2:
	var dx = normal.x;
	var dy = normal.y;
	if abs(dx) > abs(dy):
		direction.x = -direction.x
	else:
		direction.y = -direction.y
	return direction

func _update_direction_on_collision_with_angle_offset(
	direction:Vector2,
	normal:Vector2,
	bounce_mode:int #how to change bounce (enum Constants.BounceMode)
	) -> Vector2:
	if normal.y > -0.99 or bounce_mode == Constants.BounceMode.NORMAL: #only apply bounce modification if bounce on top of palette
		return _update_direction_on_collision_on_bounce(direction,normal)
	
	if bounce_mode == Constants.BounceMode.REVERSED:
		return -direction

	if bounce_mode == Constants.BounceMode.VERTICAL:
		direction.x = 0.0
		direction.y = -1.0
		return direction

	var angle = atan2(direction.y,direction.x)

	if bounce_mode == Constants.BounceMode.DECREASE_CLOCK:
		angle = angle*0.5
	elif bounce_mode == Constants.BounceMode.DECREASE_TRIGO:
		angle += (PI - angle)*0.5
	
	angle = max(angle, min_angle_in_rad)
	angle = min(angle, PI-min_angle_in_rad)
	
	direction.x = cos(angle)
	direction.y = -sin(angle)
	return direction
	

func update_direction_on_collision(
	direction:Vector2, 
	collision_info:KinematicCollision2D
	) -> Vector2:
	var collider := collision_info.collider
	var normal := collision_info.normal
	if (collider.has_method("get_bounce_mode")):
		var bounce_mode = collider.get_bounce_mode(direction, collision_info.position)
		return _update_direction_on_collision_with_angle_offset(direction, normal, bounce_mode)
	else:
		return _update_direction_on_collision_on_bounce(direction, normal)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
