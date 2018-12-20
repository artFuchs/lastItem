  extends CanvasLayer

export (Array) var levels;

func _ready():
	# load game information
	var i = 0
	var lvs = []  # lvs and keys: variables to set the game levels scenes
	var keys = [] 
	if levels:
		for l in levels:
			var b = Button.new()
			b.set_text("Level "+str(i+1));
			b.connect("pressed", self, "gotoLevel", [i])
			b.size_flags_vertical = b.SIZE_EXPAND_FILL
			if (global.get_stars() < l[1]):
				b.disabled = true
				b.set_text(b.get_text() + " - needs "+str(l[1]) + " stars to unlock");
			$PanelLevels/VBoxContainer.add_child(b);
			i+=1;
			lvs.append(l[0])
			keys.append(l[1])
	$PanelLevels.hide();
	$PanelCredits.hide();
	get_tree().paused = false;
	global.stop_music()
	global.set_level_scenes(lvs, keys)
	$LabelStars.set_text("Stars: " + str(global.get_stars()))

# loads an level
func load_level(level_num):
	get_tree().load

func exit():
	get_tree().quit()

func hide_panel(pname):
	match pname :
		"levels":
			$PanelLevels.hide()
		"credits":
			$PanelCredits.hide()

func _on_button_play_pressed():
	$PanelLevels.show()

func gotoLevel(level):
	global.goto_level(level)
	

func _on_button_credits_pressed():
	$PanelCredits.show()
