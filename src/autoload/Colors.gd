tool
extends Node


const default_indestructible_brick_color:Color = Color.gray

enum BrickType {INDESCTRUTIBLE, STANDARD}
var _brick_gradients = {}

const _brick_gradients_by_strength = [Color.green, Color.yellow, Color.orange, Color.orangered, Color.red]
	
func get_default_brick_color(strength) -> Color:
	var strength_index = strength-1	
	if strength_index<0 or strength_index >= _brick_gradients_by_strength.size():
		return _brick_gradients_by_strength[0]
	return _brick_gradients_by_strength[strength_index]


func get_brick_color(color,strength,health:float):
	var brick_color:BrickGradient = _get_brick_gradient(color)
	if brick_color == null:
		return Color.black
	else:
		var offset = 1.0-(health/strength)
		return brick_color.interpolate(offset)


func _get_brick_gradient(color) -> BrickGradient:
	if _brick_gradients.has(color):
		return _brick_gradients[color]
	var brick_color = BrickGradient.create(color)
	_brick_gradients[color] = brick_color
	return brick_color

func _clear_brick_gradients():
	_brick_gradients.clear()

func _ready():
	if not Engine.editor_hint:
		Events.connect("level_done",self,"_clear_brick_gradients")

class BrickGradient:
	var base_color:Color
	var gradient:Gradient
	
	func _initialize(color:Color):
		base_color = color
		gradient = Gradient.new()
		gradient.add_point(0, color)
		gradient.add_point(1, Color.gray)
	
	func interpolate(offset:float) -> Color:
		return gradient.interpolate(offset)

	static func create(color:Color) -> BrickGradient:
		var result:BrickGradient = BrickGradient.new()
		result._initialize(color)
		return result
