extends CanvasLayer

# in game UI interface

func _on_player_changed_items(items):
	$MarginContainer/HUD/itemDisplayer.updateItems([]+items)
	
func show_win_message():
	$CenterContainer/Label.show()
