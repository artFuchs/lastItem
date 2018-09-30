extends Node

func _ready():
	$player.connect("killed", self, "restart_scene")
	

func restart_scene():
	get_tree().reload_current_scene()
	
func pause():
	get_tree().paused = true;
	
func resume():
	get_tree().paused = false;

func _on_pause_button_pressed():
	pause();
	$CanvasLayer/PopupPauseMenu.popup();
	$CanvasLayer/pause_button.hide();


func _on_button_resume_pressed():
	resume();
	$CanvasLayer/PopupPauseMenu.hide();
	$CanvasLayer/pause_button.show();

func _on_button_retry_pressed():
	restart_scene();
	resume();
