extends StaticBody2D

signal destroyed;

#todo move Gradient to Global or another autoload
var color:Color = Color.red
var strength := 2
var health := 1
var gradient:Gradient = Gradient.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _update_color():
	var offset = 1-(0.0+health)/strength
	$Polygon2D.color = gradient.interpolate(offset)

func _decrease_health():
	health = max(0,health-1)
	_update_color()

func hit():
	if (health>0):
		_decrease_health()
		if (health <= 0):
			emit_signal(Constants.signal_brick__destroyed,strength)
			queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	gradient.add_point(0, color)
	gradient.add_point(1, Color.gray)
	health = strength
	_update_color()
	pass


func _on_Brick_body_entered(body):
	print(body)
