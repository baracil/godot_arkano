extends Node

export (PackedScene) var Ball

var balls = {}

onready var _playground:Playground = $Playground
onready var _paddle = $Paddle
onready var _timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	Levels._set_level_area($Playground/LevelArea)

	Events.connect("level_done",self,"_on_level_done")
	Events.connect("ball_lost",self,"_on_ball_lost")
	Events.connect("ball_paddle_collided",self,"_on_ball_paddle_collision")
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("brick_destroyed", self, "_on_brick_destroyed")
	Events.connect("bonus_picked",self,"_on_bonus_picked")
	_timer.connect("timeout",self, "_on_timer_timeout")

	_center_paddle()
	_reset_ball()

	State.set_score(0)
	State.set_nb_lives(3)
	Levels.load_level(1)
	

func _process(delta):
	if Input.is_action_just_released("ui_toggle_use_mouse"):
		State.toggle_use_mouse()


func _center_paddle():
	var l = get_viewport().size.x*0.5
	_paddle.position.x = get_viewport().size.x*0.5
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for id in balls:
		var ball_info:BallInfo = balls.get(id)
		ball_info.update_position_if_glu_on_paddle(_paddle)


func put_ball_on_paddle(ball:Ball):
	var paddle_sprite_size = _paddle.size();
	var ball_size = ball.size()
	
	ball.position.x = _paddle.position.x
	ball.position.y = _paddle.position.y - (paddle_sprite_size.y + ball_size.y)*0.5
	ball.set_direction(_paddle.get_bounced_direction(ball.position))
	
	_get_or_create_ball_info(ball as Ball)._offset = 0
	

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
		State.remove_one_life()
		_playground.clear_bonus()
		if State.is_player_alive():
			_reset_ball()	

func _on_brick_destroyed(strength, position):
	if (randi() % Constants.BONUS_RANGE >= strength):
		return
	var bonus_type = randi() % Constants.BonusType.size();
	_playground.pop_bonus(bonus_type, position) 	
	
func _on_bonus_picked(bonus_type:int):
	if (bonus_type == Constants.BonusType.Life):
		State.add_one_life()
	elif bonus_type == Constants.BonusType.Sticky:
		_paddle.set_timed_sticky()
	elif bonus_type == Constants.BonusType.Balls:
		_pop_new_balls()

func _pop_new_balls():
	if balls.size() > 3:
		return
	var new_balls := []
	for id in balls:
		var ball_info:BallInfo = balls.get(id)
		new_balls.append_array(ball_info.create_new_balls())

	for ball in new_balls:
		add_ball_to_game(ball)
	
func _remove_all_balls():
	for id in balls:
		var ball_info:BallInfo = balls.get(id)
		ball_info._ball.queue_free()
	balls.clear()

func _reset_ball():
	_remove_all_balls()
	var ball = ResourceLoader.load(Constants.ball_scene_path).instance()
	add_ball_to_game(ball)
	put_ball_on_paddle(ball)

func _on_level_done(level_number:int):
	_reset_ball()
	_playground.clear_bonus()
	Levels.load_level(level_number+1)
	
func _on_timer_timeout():
	_timer.stop()
	Levels.clear_level()
	Global.switch_to_intro()

func _on_player_died():
	_timer.wait_time = 5
	_timer.one_shot = true
	_timer.start()


class BallInfo:
	var _ball:Ball
	var _offset:float
	
	func update_position_if_glu_on_paddle(paddle:Node2D):
		if _ball.glu_to_paddle:
			_ball.position.x = paddle.position.x + _offset

	func create_new_balls() -> Array:
		var result:=[]
		var new_ball1:Ball = ResourceLoader.load(Constants.ball_scene_path).instance()
		var new_ball2:Ball = ResourceLoader.load(Constants.ball_scene_path).instance()
		var _direction = _ball.get_direction()
		new_ball1.glu_to_paddle = false;
		new_ball2.glu_to_paddle = false;
		new_ball1.position = _ball.position
		new_ball2.position = _ball.position
		_direction.x = -_direction.x
		new_ball1.set_direction(_direction)
		_direction.y = -_direction.y
		new_ball2.set_direction(_direction)
		return [new_ball1, new_ball2]


	static func create(ball:Ball) -> BallInfo:
		var result:BallInfo = BallInfo.new()
		result._ball = ball
		result._offset = 0
		return result
