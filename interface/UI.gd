extends CanvasLayer

onready var bm = $MarginContainer/split/buttons/music_button
onready var bfx = $MarginContainer/split/buttons/fx_button
func _ready():
	bm.pressed = !AudioServer.is_bus_mute(AudioServer.get_bus_index("music"))
	bfx.pressed = !AudioServer.is_bus_mute(AudioServer.get_bus_index("FX"))


# in game UI interface
onready var hud = $MarginContainer/split/HUD
onready var end = $EndLevelMenu
func _on_player_changed_items(items):
	hud.updateItems([]+items)
	
func show_win_message():
	end.show()
	
func update_points(points):
	hud.updatePoints(points)
	end.updatePoints(points)
	
func set_music(on):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"),!on)
		
func set_FX(on):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("FX"),!on)
