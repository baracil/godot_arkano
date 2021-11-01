extends KinematicBody2D


export var speed := 600;

export(bool) var _sticky

onready var sprite: Sprite = $Sprite;

enum BounceZone {LEFT, MIDDLE_LEFT, DEAD_ZONE, MIDDLE_RIGHT, RIGHT}

#return
# -1 when position left of dead zone
#  0 when position in dead zone
#  1 when position right of dead zone
func _compute_bounce_zone(collision_position:Vector2) -> int:
	var sprite_width = sprite.get_rect().size.x;
	var alpha = 8*(collision_position.x-position.x)/sprite_width;
	print("alpha=",alpha)
	if alpha < -2.5:
		return BounceZone.LEFT
	elif alpha < -1.5:
		return BounceZone.MIDDLE_LEFT
	elif alpha < 1.5:
		return BounceZone.DEAD_ZONE
	elif alpha < 2.5:
		return BounceZone.MIDDLE_RIGHT
	else:
		return BounceZone.RIGHT


func get_bounce_mode(
	direction:Vector2, #the direction the ball comes from
	collision_position:Vector2 # the position of the collision
	) -> int:
	var coming_from_left = direction.x > 0
	var coming_from_right = direction.x < 0
	var zone = _compute_bounce_zone(collision_position)
	
	var mode = Constants.BounceMode.NORMAL
	
	if zone == BounceZone.LEFT:
		mode = Constants.BounceMode.REVERSED if coming_from_left else Constants.BounceMode.DECREASE_TRIGO
	elif zone == BounceZone.MIDDLE_LEFT:
		if coming_from_left:
			mode = Constants.BounceMode.VERTICAL
		elif coming_from_right:
			mode = Constants.BounceMode.NORMAL
		else:
			mode = Constants.BounceMode.DECREASE_TRIGO
	elif zone == BounceZone.MIDDLE_RIGHT:
		if coming_from_right:
			mode = Constants.BounceMode.VERTICAL
		elif coming_from_left:
			mode = Constants.BounceMode.NORMAL
		else:
			mode = Constants.BounceMode.DECREASE_CLOCK
	elif zone == BounceZone.RIGHT:
		mode = Constants.BounceMode.REVERSED if coming_from_right else Constants.BounceMode.DECREASE_CLOCK
	else:
		mode = Constants.BounceMode.NORMAL
		
	print("from_left=",coming_from_left, " from_right=",coming_from_right," zone=",zone, "  mode=",mode)
	return mode
	
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
