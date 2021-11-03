extends KinematicBody2D
class_name Paddle

export var speed := 600;

export(bool) var _sticky

onready var _sprite: Sprite = $Sprite
onready var _timer:Timer = $StickyTimer

func size() -> Vector2:
	var scale:Vector2 = transform.get_scale()
	var size:Vector2 = _sprite.get_rect().size
	size.x *= scale.x
	size.y *= scale.y
	return size

#return
# -1 when position left of dead zone
#  0 when position in dead zone
#  1 when position right of dead zone
func get_bounce_angle(
	collision_position:Vector2) -> float:
	var sprite_width = size().x;
	var alpha = 8*2*(collision_position.x-position.x)/sprite_width;
	if alpha < -6:
		return Constants.BouncedAngle[0]
	elif alpha < -2.5:
		return Constants.BouncedAngle[1]
	elif alpha < 0:
		return Constants.BouncedAngle[2]
	elif alpha < 2.5:
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
	if State.get_use_mouse():
		var viewport = get_viewport_rect()
		var mouse = get_global_mouse_position()
		if (mouse.x < 10 or mouse.x > viewport.size.x-10):
			return
		mouse = get_local_mouse_position()
		mouse.y = 0;
		move_and_collide(mouse)
	else:
		if (Input.is_action_pressed("ui_left")):
			direction.x -= 1
		if (Input.is_action_pressed("ui_right")):
			direction.x += 1
		move_and_collide(direction*speed*delta)


func set_sticky(sticky:bool):
	_sticky = sticky

func set_timed_sticky():
	set_sticky(true)
	_timer.one_shot = true
	_timer.start(10)
	
func is_sticky():
	return _sticky

func _on_sticky_timer_timeout():
	set_sticky(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.connect("timeout",self,"_on_sticky_timer_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	process_input(delta)
	
