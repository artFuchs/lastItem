extends Node

var crowns

func _ready():
	$player.connect("killed", self, "restart_scene")
	$player.connect("changed_items",self, "_player_changed_items")

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