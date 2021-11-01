extends Node

export (PackedScene) var Ball

var balls = {}
var balls_offsets = {}

onready var _paddle = $Paddle
onready var _paddle_sprite = $Paddle/Sprite




# Called when the node enters the scene tree for the first time.
func _ready():
	Levels._set_level_area($Playground/LevelArea)

	Events.connect("level_done",self,"_on_level_done")
	Events.connect("ball_lost",self,"_on_ball_lost")
	Events.connect("player_died",self,"_on_player_died")
	Events.connect("nb_lives_changed", self,"_on_nb_lives_changed")
	Events.connect("ball_paddle_collided",self,"_on_ball_paddle_collision")

	Global.set_nb_lives(3)
	Levels.load_level(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):

	for id in balls:
		var ball_info:BallInfo = balls.get(id)
		ball_info.update_position_if_glu_on_paddle(_paddle)


func put_ball_on_paddle(ball:KinematicBody2D, offset:float = 0):
	var paddle_sprite_size = _paddle_sprite.get_rect().size;
	var ball_size = ball.get_node("Sprite").get_rect().size
	
	var ball_x_offset = offset;
	ball.position.x = _paddle.position.x + ball_x_offset
	ball.position.y = _paddle.position.y - (paddle_sprite_size.y + ball_size.y)*0.5
	ball.set_direction(_paddle.get_bounced_direction(ball.position))
	
	_get_or_create_ball_info(ball as Ball)._offset = ball_x_offset
	

func add_ball_to_game(ball:KinematicBody2D):
	balls[ball.get_instance_id()] = BallInfo.create(ball)
	call_deferred("add_child",ball)


func _on_ball_paddle_collision(
	ball:Node2D, 
	collision_info:KinematicCollision2D
	):
	var paddle = collision_info.collider
	if paddle.is_sticky() and !ball.glu_to_paddle:
		ball.glu_to_paddle = true
		ball.set_direction(paddle.get_bounced_direction(collision_info.position))
		var ball_info:BallInfo = _get_or_create_ball_info(ball)
		ball_info._offset = ball.position.x - paddle.position.x
		

func _get_or_create_ball_info(ball:Ball) -> BallInfo:
	var ball_info = balls[ball.get_instance_id()]
	if ball_info == null:
		ball_info = BallInfo.create(ball)
		balls[ball.get_instance_id()] = ball_info
	return ball_info
	

func _on_ball_lost(body:Node):
	var ball_id = body.get_instance_id()
	var ball_info:BallInfo = balls.get(ball_id)
	if ball_info == null:
		return
	balls.erase(ball_id)
	ball_info._ball.queue_free()
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
	var _ball:Ball
	var _offset:float
	
	func update_position_if_glu_on_paddle(paddle:Node2D):
		if _ball.glu_to_paddle:
			_ball.position.x = paddle.position.x + _offset

	static func create(ball:Ball) -> BallInfo:
		var result:BallInfo = BallInfo.new()
		result._ball = ball
		result._offset = 0
		return result


