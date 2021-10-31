extends Node

export var min_angle:=5 setget set_min_angle
var min_angle_in_rad:=5.0*PI/180

func set_min_angle(value):
	min_angle = value
	min_angle_in_rad = deg2rad(value)

## Update the provided direction to simulate a bounce on a wall.
##  direction: the direction to update
##  normal : the normal of the collision
##
func _update_direction_on_collision_on_wall(
	direction:Vector2,
	normal:Vector2
	)-> Vector2:
	var collinear_factor = 2*direction.dot(normal)
	direction -= collinear_factor*normal
	return direction


func _update_direction_on_collision_with_angle_offset(
	direction:Vector2,
	collision_info:KinematicCollision2D,
	angle_offset:float
	) -> Vector2:
		#todo
#this only workd for the palette (more generally when the normal is vertical)
	var angle = atan2(direction.y,direction.x)
	angle += angle_offset
	
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
	if (collider.has_method("bounce_angle_offset")):
		var angle_offset = collider.bounce_angle_offset(collision_info.position)
		return _update_direction_on_collision_with_angle_offset(direction,collision_info,angle_offset)
	else:
		return direction.bounce(collision_info.normal)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
