extends Node

signal game_over

export (PackedScene) var Ball

var balls = {}
var balls_offsets = {}

onready var paddle = $Paddle
onready var paddle_sprite = $Paddle/Sprite




# Called when the node enters the scene tree for the first time.
func _ready():
	Levels._set_level_area($Playground/LevelArea)

	Events.connect("level_done",self,"_on_level_done")
	Events.connect("ball_lost",self,"_on_ball_lost")
	Events.connect("player_died",self,"_on_player_died")
	Events.connect("score_changed",self,"_update_on_score_changed")
	Events.connect("nb_lives_changed", self,"_on_nb_lives_changed")

	Global.set_nb_lives(3)
	Levels.load_level(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for id in balls:
		var ball_info:BallInfo = balls.get(id)
		ball_info.update_position_if_glu_on_paddle(paddle)


func put_ball_on_paddle(ball:KinematicBody2D, offset:float = 0):
	var paddle_sprite_size = paddle_sprite.get_rect().size;
	var ball_size = ball.get_node("Sprite").get_rect().size
	
	var ball_x_offset = offset;
	ball.position.x = paddle.position.x + ball_x_offset
	ball.position.y = paddle.position.y - (paddle_sprite_size.y + ball_size.y)*0.5
	ball.set_direction(paddle.get_bounced_direction(ball.position))
	
	_get_or_create_ball_info(ball as Ball).offset = ball_x_offset
	

func add_ball_to_game(ball:KinematicBody2D):
	balls[ball.get_instance_id()] = BallInfo.create(ball,0)
	add_child(ball)


func _on_ball_paddle_collision(ball:Node2D, collision_info:KinematicCollision2D):
	var paddle = collision_info.collider
	if paddle.is_sticky() and !ball.glu_to_paddle:
		ball.glu_to_paddle = true
		ball.direction = paddle.get_bounced_direction(collision_info.position)
		var ball_info = _get_or_create_ball_info(ball)
		ball_info.offset = ball.position.x - paddle.position.x
		

func _get_or_create_ball_info(ball:Ball) -> BallInfo:
	var ball_info = balls[ball.get_instance_id()]
	if ball_info == null:
		ball_info = BallInfo.create(ball,0)
		balls[ball.get_instance_id()] = ball_info
	return ball_info
	

func _on_ball_lost(body:Node):
	var ball_id = body.get_instance_id()
	var ball_info:BallInfo = balls.get(ball_id)
	if ball_info == null:
		return
	balls.erase(ball_id)
	ball_info.ball.queue_free()
	if (balls.empty()):
		Global.remove_one_life()
	

func _on_nb_lives_changed(nb_lives):
	if nb_lives > 0:
		_reset_ball()	

func _on_player_died():
	print("Game Over") # Replace with function body.

	
func _remove_all_balls():
	for id in balls:
		var ball = balls.get(id)
		ball.paddle=null
		ball.queue_free()
	balls.clear()

func _reset_ball():
	_remove_all_balls()
	var ball = ResourceLoader.load(Constants.ball_scene_path).instance()
	add_ball_to_game(ball)
	put_ball_on_paddle(ball)

func _on_level_done(level_number:int):
	_reset_ball()
	Levels.load_level(level_number+1)
	

class BallInfo:
	var ball:Ball
	var offset:float
	
	func update_position_if_glu_on_paddle(paddle:Node2D):
		if ball.glu_to_paddle:
			ball.position.x = paddle.position.x + offset

	static func create(ball:Ball,offset:float) -> BallInfo:
		var result:BallInfo = BallInfo.new()
		result.ball = ball
		result.offset = offset
		return result


