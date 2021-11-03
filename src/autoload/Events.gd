extends Node

signal level_done(level_number) 
signal brick_destroyed(brick_strength, brick_position)
signal player_died
signal game_over
signal ball_lost()
signal ball_paddle_collided(ball,collision_info)
signal game_started

signal bonus_picked(bonus_type)

signal nb_lives_changed(nb_lives)
signal score_changed(score)
signal level_number_changed(level_number)
signal use_mouse_changed(use_mouse)
