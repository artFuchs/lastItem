extends PopupPanel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(NodePath) var triggerButtonPath
var triggerButton

func _ready():
	if triggerButtonPath:
		triggerButton = get_node(triggerButtonPath)
	if triggerButton:
		triggerButton.connect("pressed", self, "_on_pause_button_pressed");
	connect("popup_hide", self, "_on_popup_hide")

func _on_pause_button_pressed():
	triggerButton.disabled = true
	for b in $VBoxContainer.get_children():
		if b is Button:
			b.disabled = false
			b.disabled = false
	popup_centered()
	get_tree().paused = true

func _on_retry_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	pass

func _on_resume_button_pressed():
	hide()
	get_tree().paused = false
	pass
	
func _on_button_menu_pressed():
	get_tree().paused = false
	get_node("/root/global").goto_scene_path("res://interface/main menu.tscn");

func _on_popup_hide():
	triggerButton.disabled = false
	for b in $VBoxContainer.get_children():
		if b is Button:
			b.disabled = false
			b.disabled = false
	_on_resume_button_pressed()

