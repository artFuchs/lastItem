extends Node

func _ready():
	$player.connect("killed", self, "restart_scene")	

func restart_scene():
	get_tree().reload_current_scene()
	
func pause():
	get_tree().paused = true;
	
func resume():
	get_tree().paused = false;

func _on_flag_level_end():
	$UI.show_win_message()
