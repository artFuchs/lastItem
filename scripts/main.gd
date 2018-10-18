extends Node

export(NodePath) var pauseMenuPath;
export(NodePath) var pauseButtonPath;
var pauseMenu = null;
var pauseButton = null;

func _ready():
	pauseMenu = get_node(pauseMenuPath);
	pauseButton = get_node(pauseButtonPath);
	$player.connect("killed", self, "restart_scene")
	

func restart_scene():
	get_tree().reload_current_scene()
	
func pause():
	get_tree().paused = true;
	
func resume():
	get_tree().paused = false;

func _on_pause_button_pressed():
	pause();
	pauseMenu.popup();
	pauseButton.hide();


func _on_button_resume_pressed():
	resume();
	pauseMenu.hide();
	pauseButton.show();

func _on_button_retry_pressed():
	restart_scene();
	resume();
