extends Node

var points;

func _ready():
	points = 0
	$player.connect("killed", self, "restart_scene")
	$player.connect("changed_items",self, "_player_changed_items")
	for p in get_tree().get_nodes_in_group("points"):
		p.connect("body_entered", self, "_on_point_collected", [p])

func restart_scene():
	get_tree().reload_current_scene()
	
func pause():
	get_tree().paused = true;
	
func resume():
	get_tree().paused = false;

func _on_flag_level_end():
	$UI.show_win_message()
	
func _player_changed_items(items):
	$UI._on_player_changed_items(items);
	
func _on_point_collected(collector, p):
	if collector.is_in_group("player"):
		p.queue_free()
		points += 1
		$UI.update_points(points)