extends CanvasLayer

# in game UI interface
onready var hud = $MarginContainer/HUD
onready var end = $EndLevelMenu
func _on_player_changed_items(items):
	hud.updateItems([]+items)
	
func show_win_message():
	end.show()
	
func update_points(points):
	hud.updatePoints(points)
	end.updatePoints(points)
