extends CanvasLayer

# in game UI interface

func _on_player_changed_items(items):
	$MarginContainer/HUD/itemDisplayer.updateItems([]+items)
