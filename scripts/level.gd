extends Node

var next_level;
var stars;

func _ready():
	stars = 0
	$player.connect("killed", self, "restart_scene")
	$player.connect("changed_items",self, "_player_changed_items")
	for p in get_tree().get_nodes_in_group("points"):
		p.connect("body_entered", self, "_on_point_collected", [p])
	for f in get_tree().get_nodes_in_group("flag"):
		f.connect("level_end", self, "_on_flag_level_end")
	global.start_music()

func restart_scene():
	get_tree().reload_current_scene()
	
func pause():
	get_tree().paused = true;
	
func resume():
	get_tree().paused = false;

func _on_flag_level_end():
	global.set_level_stars(stars)
	$UI.show_win_message()
	
func _player_changed_items(items):
	$UI._on_player_changed_items(items);
	
func _on_point_collected(collector, s):
	if collector.is_in_group("player"):
		s.queue_free()
		stars += 1
		$UI.update_points(stars)
		$AudioPlayerStar.play()