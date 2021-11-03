extends Control


onready var _score:Label = $Panel/GridContainer/Score
onready var _level:Label = $Panel/GridContainer/Level
onready var _animation:AnimationPlayer = $CenterContainer/GameOverAnimation
func _ready():
	Events.connect("score_changed",self,"_on_score_changed")
	Events.connect("level_number_changed", self, "_on_level_number_changed")
	Events.connect("game_started",self,"_on_game_started")
	Events.connect("player_died",self,"_on_player_died")
	_on_game_started()
	

func _on_player_died():
	_animation.play("New Anim")

func _on_score_changed(score):
	_score.text = "%06d" % score
	
	
func _on_level_number_changed(level_number):
	_level.text = "%04d" % level_number


func _on_game_started():
	_animation.stop(true)
	_animation.seek(0)
