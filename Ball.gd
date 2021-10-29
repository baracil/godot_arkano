extends KinematicBody2D

export (PackedScene) var Palette


signal lost
signal ball_palette_collision

var palette;

var glu_to_palette = true

var direction = Vector2(0,0)
var speed_factor = 1
export var base_speed = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()
	update_position()

func process_input():
	if (Input.is_action_pressed("ui_launch_ball") and glu_to_palette):
		glu_to_palette = false
		direction.y = -1;
		direction.x = 0;
		direction = direction.normalized()

func update_position():
	var collision_info = move_and_collide(direction*base_speed*speed_factor)
	if (not collision_info == null):
		Global._hit(collision_info.collider)
		var collider = collision_info.collider
		if (collider.is_in_group(Global.palette_group)):
			emit_signal("ball_palette_collision", self, collision_info)

		print("Hello")
		if not glu_to_palette:
			direction = Physics._update_direction_on_collision(direction,collision_info)
		


func _on_VisibilityNotifier2D_screen_exited():
	print("Emit ball lost")
	emit_signal("lost", get_instance_id())	
