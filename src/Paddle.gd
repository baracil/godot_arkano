extends KinematicBody2D


export var speed := 600;

export(bool) var _sticky

onready var sprite: Sprite = $Sprite;

#return
# -1 when position left of dead zone
#  0 when position in dead zone
#  1 when position right of dead zone
func get_bounce_angle(
	collision_position:Vector2) -> float:
	var sprite_width = sprite.get_rect().size.x;
	var alpha = 8*2*(collision_position.x-position.x)/sprite_width;
	if alpha < -6:
		return Constants.BouncedAngle[0]
	elif alpha < -2:
		return Constants.BouncedAngle[1]
	elif alpha < 0:
		return Constants.BouncedAngle[2]
	elif alpha < 2:
		return Constants.BouncedAngle[3]
	elif alpha < 6:
		return Constants.BouncedAngle[4]
	else:
		return Constants.BouncedAngle[5]

func get_bounced_direction(collision_position:Vector2) -> Vector2:
	var bounce_angle = get_bounce_angle(collision_position)
	var angle = PI/2 + bounce_angle/180*PI
	var direction = Vector2(cos(angle),-sin(angle))
	return direction

func process_input(delta):
	var direction = Vector2(0,0);
	if (Input.is_action_pressed("ui_left")):
		direction.x -= 1
	if (Input.is_action_pressed("ui_right")):
		direction.x += 1
	move_and_collide(direction*speed*delta);
	

func set_sticky(sticky:bool):
	_sticky = sticky

func is_sticky():
	return _sticky

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	process_input(delta)
