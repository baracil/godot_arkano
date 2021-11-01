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
func _update_direction_on_bounce(
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
	

func update_direction_on_collision(
	direction:Vector2, 
	collision_info:KinematicCollision2D
	) -> Vector2:
	var collider := collision_info.collider
	var normal := collision_info.normal
	if (collider.has_method("get_bounced_direction")):
		return collider.get_bounced_direction(collision_info.position)
	else:
		return _update_direction_on_bounce(direction, normal)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
