extends Node

const group_brick = "Brick"
const group_ball = "Ball"
const group_palette = "Palette"

const signal_ball__palette_collision = "palette_collision"
const signal_ball__lost = "lost"
const signal_level__level_done = "level_done"

const signal_brick__destroyed = "destroyed"

const ball_scene_path = "res://src/Ball.tscn"


func level_scene_path(level_number:int) -> String :
	return "res://src/levels/Level_%04d.tscn" % level_number

func _ready():
	pass
