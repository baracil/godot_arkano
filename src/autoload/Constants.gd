tool
extends Node

const group_brick = "Brick"
const group_ball = "Ball"
const group_palette = "Palette"

const signal_ball__palette_collision = "palette_collision"
const signal_ball__lost = "lost"
const signal_level__level_done = "level_done"

const signal_global__score_changed = "score_changed"

const signal_brick__destroyed = "destroyed"

const ball_scene_path = "res://src/Ball.tscn"





func level_scene_path(level_number:int) -> String :
	var group = (level_number/10)*10+1
	return "res://src/levels/level_%04d/Level_%04d.tscn" % [group,level_number]

func _ready():
	_update_brick_colors()



enum BrickType {INDESCTRUTIBLE, STANDARD}
var _brick_colors = {}

const _brick_base_colors = [Color.green, Color.yellow, Color.orange, Color.orangered, Color.red]

func _update_brick_colors():
	for i in range(0,_brick_base_colors.size()):
		var brick_color:BrickColor = BrickColor.new()
		brick_color._initialize(_brick_base_colors[i])
		_brick_colors[i+1] = brick_color
	

func get_brick_color(type,strength,health:float):
	if type == BrickType.INDESCTRUTIBLE:
		return Color.gray
	elif type == BrickType.STANDARD:
		var brick_color:BrickColor = _get_brick_color(strength)
		if brick_color == null:
			return Color.black
		else:
			var offset = 1.0-(health/strength)
			return brick_color.interpolate(offset)

func _get_brick_color(strength):
	var strength_index = strength-1
	if strength_index<0 or strength_index >= _brick_base_colors.size():
		return null
	if _brick_colors.has(strength):
		return _brick_colors[strength]
	var brick_color = BrickColor.new()
	brick_color._initialize(_brick_base_colors[strength_index])
	_brick_colors[strength] = brick_color
	return brick_color

class BrickColor:
	var base_color:Color
	var gradient:Gradient
	
	func _initialize(color:Color):
		base_color = color
		gradient = Gradient.new()
		gradient.add_point(0, color)
		gradient.add_point(1, Color.gray)
	
	func interpolate(offset:float) -> Color:
		return gradient.interpolate(offset)


