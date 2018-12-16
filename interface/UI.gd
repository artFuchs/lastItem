extends CanvasLayer

# in game UI interface
onready var hud = $MarginContainer/HUD
func _on_player_changed_items(items):
	hud.updateItems([]+items)
	
func show_win_message():
	$EndLevelMenu.popup_centered();
	
func _on_resume_button_pressed():
	pass # replace with function body

func _on_retry_button_pressed():
	pass # replace with function body
	
func update_points(points):
	hud.updatePoints(points)
