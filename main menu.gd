  extends CanvasLayer

export (Array) var levels;

func _ready():
	# load game information
	var i = 0
	if levels:
		for l in levels:
			var b = Button.new()
			b.set_text("Level "+str(i+1));
			b.connect("pressed", self, "gotoLevel", [i])
			b.size_flags_vertical = b.SIZE_EXPAND_FILL
			$PanelLevels/VBoxContainer.add_child(b);
			i+=1;
	$PanelLevels.hide();
	get_tree().paused = false;

# loads an level
func load_level(level_num):
	get_tree().load

func exit():
	get_tree().quit()

func hide_panel(pname):
	match pname :
		"levels":
			$PanelLevels.hide()

func _on_button_play_pressed():
	$PanelLevels.show()
	

func gotoLevel(level):
	var path = levels[level]
	get_node("/root/global").goto_scene(path)