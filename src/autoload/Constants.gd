tool
extends Node

const group_brick = "Brick"
const group_ball = "Ball"
const group_palette = "Palette"

const signal_ball__palette_collision = "palette_collision"
const signal_ball__lost = "lost"
const signal_level__level_done = "level_done"
const signal_global__score_changed = "score_changed"
const signal_global__player_died = "player_died"
const signal_global__nb_lives_changed = "nb_lives_changed"
const signal_brick__destroyed = "destroyed"

const ball_scene_path = "res://src/Ball.tscn"
const hud_palette_scene_path = "res://src/HUDPalette.tscn"


func level_scene_path(level_number:int) -> String :
	var group = (level_number/10)*10+1
	return "res://src/levels/level_%04d/Level_%04d.tscn" % [group,level_number]


const default_indestructible_brick_color:Color = Color.gray

enum BrickType {INDESCTRUTIBLE, STANDARD}
var _brick_colors = {}

const _brick_colors_by_strength = [Color.green, Color.yellow, Color.orange, Color.orangered, Color.red]
	
func get_default_brick_color(strength) -> Color:
	var strength_index = strength-1	
	if strength_index<0 or strength_index >= _brick_colors_by_strength.size():
		return _brick_colors_by_strength[0]
	return _brick_colors_by_strength[strength_index]
	
func get_brick_color(color,strength,health:float):
	var brick_color:BrickColor = _get_brick_color(color)
	if brick_color == null:
		return Color.black
	else:
		var offset = 1.0-(health/strength)
		return brick_color.interpolate(offset)

func _get_brick_color(color):
	if _brick_colors.has(color):
		return _brick_colors[color]
	var brick_color = BrickColor.new()
	brick_color._initialize(color)
	_brick_colors[color] = brick_color
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


