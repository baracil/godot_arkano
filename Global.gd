extends Node

var brick_group = "Brick"
var ball_group = "Ball"
var palette_group = "Palette"

var score:int = 0

func _lerp(color_start:Color,color_end:Color, t:float) -> Color: 
	var color:Color = color_end
	color.h = color_start.h*(1-t)+color_end.h*t
	color.s = color_start.s*(1-t)+color_end.s*t
	color.v = color_start.v*(1-t)+color_end.v*t
	
	return color

func _hit(hit_object):
	if (hit_object.has_method("hit")):
		hit_object.hit()

func _ready():
	pass # Replace with function body.

