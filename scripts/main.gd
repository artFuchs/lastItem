extends Node

func _ready():
	$player.connect("killed", self, "restart_scene")
		

func restart_scene():
	get_tree().reload_current_scene()
	
