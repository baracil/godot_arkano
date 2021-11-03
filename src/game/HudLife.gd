extends Position2D

var _hub_lives_displayed = []

func _ready():
	Events.connect("nb_lives_changed",self,"_on_nb_lives_changed")

func _on_nb_lives_changed(nb_lives):
	while _hub_lives_displayed.size() > nb_lives:
		_remove_one_hud_life()
	while _hub_lives_displayed.size() < nb_lives:
		_add_one_hud_life()

func _remove_one_hud_life():
	if _hub_lives_displayed.empty():
		return
	var hud_live:Node = _hub_lives_displayed.pop_back();
	self.remove_child(hud_live)
	hud_live.queue_free()

func _add_one_hud_life():
	var nb_displayed = _hub_lives_displayed.size()
	var hud_paddle:Node2D = ResourceLoader.load(Constants.hud_paddle_scene_path).instance()
	hud_paddle.position.x = 50*nb_displayed
	hud_paddle.position.y = 0
	_hub_lives_displayed.append(hud_paddle)
	self.add_child(hud_paddle)


