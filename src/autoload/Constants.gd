extends Node

const group_brick = "Brick"
const group_ball = "Ball"
const group_paddle = "Paddle"

const ball_scene_path = "res://src/game/Ball.tscn"
const hud_paddle_scene_path = "res://src/game/HUDPaddle.tscn"

const BouncedAngle = PoolRealArray([60,45,30,-30,-45,-60])

func level_scene_path(level_number:int) -> String :
	var group = (level_number/10)*10+1
	return "res://src/game/levels/level_%04d/Level_%04d.tscn" % [group,level_number]
