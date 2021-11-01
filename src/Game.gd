extends Node

signal game_over

export (PackedScene) var Ball

var balls = {}
var balls_offsets = {}
var hub_lives_displayed = []

onready var hud_lives_origin = 	$Playground/Position2D
onready var palette = $Palette
onready var palette_sprite = $Palette/Sprite


func put_ball_on_palette(ball:KinematicBody2D, offset:float = 0):
	var palette_sprite_size = palette_sprite.get_rect().size;
	var ball_size = ball.get_node("Sprite").get_rect().size
	
	var ball_x_offset = offset;
	ball.position.x = palette.position.x + ball_x_offset
	ball.position.y = palette.position.y - (palette_sprite_size.y + ball_size.y)*0.5

	balls_offsets[ball.get_instance_id()] = ball_x_offset
	

func add_ball_to_game(ball:KinematicBody2D):
	ball.palette = palette
	balls[ball.get_instance_id()] = ball
	add_child(ball)
	ball.connect(Constants.signal_ball__lost, self, "_on_ball_lost")
	ball.connect(Constants.signal_ball__palette_collision, self, "_on_ball_palette_collision")
	

func _on_ball_palette_collision(ball:Node2D, collision_info:KinematicCollision2D):
	var palette = collision_info.collider
	if palette.is_sticky() and !ball.glu_to_palette:
		ball.glu_to_palette = true
		balls_offsets[ball.get_instance_id()] = ball.position.x - palette.position.x
		
	
func _on_ball_lost(body:Node):
	var ball_id = body.get_instance_id()
	var ball = balls.get(ball_id)
	if ball == null:
		return
	ball.palette=null
	balls.erase(ball_id)
	ball.queue_free()
	if (balls.empty()):
		Global.remove_one_life()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$Playground/DeathLine.connect("body_entered",self,"_on_ball_lost")
	
	Levels._set_level_area($Playground/LevelArea)
	Levels.connect("level_done",self,"_on_level_done")
	
	Global.connect(Constants.signal_global__score_changed,self,"_update_on_score_changed")
	Global.connect("nb_lives_changed", self,"_on_nb_lives_changed")
	Global.connect("player_died", self,"_on_player_died")

	_update_on_score_changed()
	_on_nb_lives_changed()
	Levels.load_level(1)
	
func _update_on_score_changed():
	var score:String = String(Global.get_score());

func _remove_all_balls():
	for id in balls:
		var ball = balls.get(id)
		ball.palette=null
		ball.queue_free()
	balls.clear()

func _on_nb_lives_changed():
	var nb_lives = Global.get_nb_lives()
	while hub_lives_displayed.size() > nb_lives:
		_remove_one_hud_life()
	while hub_lives_displayed.size() < nb_lives:
		_add_one_hud_life()
	if (nb_lives>0):
		_reset_ball()
	else:
		_on_Game_game_over()

func _remove_one_hud_life():
	if hub_lives_displayed.empty():
		return
	var hud_live:Node = hub_lives_displayed.pop_back();
	hud_lives_origin.remove_child(hud_live)
	hud_live.queue_free()

func _add_one_hud_life():
	var nb_displayed = hub_lives_displayed.size()
	var hud_palette:Node2D = ResourceLoader.load(Constants.hud_palette_scene_path).instance()
	hud_palette.position.x = 50*nb_displayed
	hud_palette.position.y = 0
	hub_lives_displayed.append(hud_palette)
	hud_lives_origin.add_child(hud_palette)


func _reset_ball():
	_remove_all_balls()
	var ball = ResourceLoader.load(Constants.ball_scene_path).instance()
	add_ball_to_game(ball)
	put_ball_on_palette(ball)

func _on_level_done(level_number:int):
	_reset_ball()
	Levels.load_level(level_number+1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for id in balls:
		var ball = balls.get(id)
		if ball.glu_to_palette:
			ball.position.x = palette.position.x + balls_offsets.get(id)


func _on_Game_game_over():
	print("Game Over") # Replace with function body.
