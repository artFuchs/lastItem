extends PopupPanel

var stars = 0

func _ready():
	$VBoxContainer/button_back.connect("pressed", self, "_on_menu_button_pressed")
	$VBoxContainer/button_again.connect("pressed", self, "_on_retry_button_pressed")
	$VBoxContainer/button_next.connect("pressed", self, "_on_next_button_pressed")
	
func _on_menu_button_pressed():
	get_tree().paused = false
	get_node("/root/global").goto_scene_path("res://interface/main menu.tscn");

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_next_button_pressed():
	pass

onready var starsPanel = $VBoxContainer/stars
func show():
	var i = 0
	for s in starsPanel.get_children():
		i += 1
		s.set_modulate(Color(1,1,1))
		if i == stars:
			break
	popup_centered()

func updatePoints(points):
	stars = points