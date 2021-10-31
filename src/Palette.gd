extends KinematicBody2D


export var speed := 600;
export var dead_zone := 0.125;
export var angle_factor = 1 setget set_angle_factor

var screen_size
export(bool) var _sticky

func set_angle_factor(new_value):
	angle_factor = max(0,angle_factor)

onready var sprite: Sprite = $Sprite;

func update_screen_size():
	screen_size = get_viewport_rect().size

func update_palette_height():
	position.y = screen_size.y-sprite.get_rect().size.y*0.5

func center_palette_horizontally():
	position.x = screen_size.x*0.5	

func _compute_centering_factor(collision_position:Vector2):
	var sprite_width = sprite.get_rect().size.x;
	return 2*(position.x - collision_position.x)/sprite_width;


func bounce_angle_offset(collision_position:Vector2):
	var alpha = _compute_centering_factor(collision_position)
	if (abs(alpha)<=dead_zone):
		return 0;
	return angle_factor*alpha;	
	
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
	update_screen_size()
	center_palette_horizontally()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	process_input(delta)


func _on_Palette_body_entered(body):
	print(body)
