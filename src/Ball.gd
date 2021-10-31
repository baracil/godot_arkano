extends KinematicBody2D

export (PackedScene) var Palette

signal lost
signal palette_collision

var palette;

var glu_to_palette = true

var direction = Vector2(0,0)
var velocity = Vector2(0,0)
var speed_factor = 1
export var base_speed = 360 setget set_base_speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_base_speed(value):
	base_speed = value
	update_velocity()

func set_direction(value):
	direction = value
	update_velocity()

func update_velocity():
	velocity = direction*speed_factor*base_speed


func _physics_process(delta):
	process_input()
	update_position(delta)

func process_input():
	if (Input.is_action_pressed("ui_launch_ball") and glu_to_palette):
		glu_to_palette = false
		set_direction(Vector2(0,-1))



func update_position(delta):
	var collision_info = move_and_collide(velocity*delta)
	if (collision_info == null):
		return
	#call hit on collider if it exists
	Global.hit(collision_info.collider)

	#todo handle remaining
	var collider = collision_info.collider
	if (collider.is_in_group(Constants.group_palette)):
		emit_signal(Constants.signal_ball__palette_collision, self, collision_info)

	if not glu_to_palette:
		set_direction(Physics.update_direction_on_collision(direction,collision_info))
