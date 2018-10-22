extends PopupPanel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(NodePath) var pauseButtonPath
var pauseButton

func _ready():
	pauseButton = get_node(pauseButtonPath)
	pauseButton.connect("pressed", self, "_on_pause_button_pressed");
	$VBoxContainer/button_retry.connect("pressed", self, "_on_retry_button_pressed")
	$VBoxContainer/button_resume.connect("pressed", self, "_on_resume_button_pressed")
	connect("popup_hide", self, "_on_popup_hide")

func _on_pause_button_pressed():
	pauseButton.disabled = true
	$VBoxContainer/button_retry.disabled = false
	$VBoxContainer/button_resume.disabled = false
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
	
func _on_popup_hide():
	pauseButton.disabled = false
	$VBoxContainer/button_retry.disabled = true
	$VBoxContainer/button_resume.disabled = true
	_on_resume_button_pressed()