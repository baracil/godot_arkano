extends Area2D


func _ready():
	pass


func _on_DeathLine_body_entered(body):
	if body.is_in_group(Constants.group_ball):
		Events.emit_signal("ball_lost",body)
