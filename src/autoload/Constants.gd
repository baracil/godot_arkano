tool
extends Node

const group_brick = "Brick"
const group_ball = "Ball"
const group_bonus = "Bonus"
const group_paddle = "Paddle"

const ball_scene_path = "res://src/game/Ball.tscn"
const hud_paddle_scene_path = "res://src/game/HUDPaddle.tscn"
const game_scene_path = "res://src/game/Game.tscn"
const intro_scene_path = "res://src/intro/Intro.tscn"
const bonus_scene_path = "res://src/game/Bonus.tscn"

const BouncedAngle = PoolRealArray([60,45,30,-30,-45,-60])


enum BonusType {Life, Balls, Sticky}

var BONUS_RANGE = 20

func level_scene_path(level_number:int) -> String :
	var group = (level_number/10)*10+1
	return "res://src/game/levels/level_%04d/Level_%04d.tscn" % [group,level_number]
