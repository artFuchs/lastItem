extends Node

var level = -1;

var game = {
	"stars" : 0,
	"level_stars" : [],
	"level_keys" : [],
	"levels" : []
}

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)

func goto_level(lv):
	level = lv;
	if (game["levels"][lv]):
		goto_scene(game["levels"][lv])
	else:
		print("/root/global - goto_level(" + str(lv) + ") - level not found")

func goto_scene_path(path):
	var scene = ResourceLoader.load(path);
	call_deferred("_deferred_goto_scene", scene)

func _deferred_goto_scene(scene):
	# Immediately free the current scene, there is no risk here.
	get_tree().get_current_scene().free()

	# Instance the new scene
	var instanced_scene = scene.instance()

	# Add it to the scene tree, as direct child of root
	get_tree().get_root().add_child(instanced_scene)

	# Set it as the current scene, only after it has been added to the tree
	get_tree().set_current_scene(instanced_scene)

func set_level_stars(stars):
	game["level_stars"][level] = stars
	var total_stars = 0
	for s in game["level_stars"]:
		total_stars += s
	game["stars"] = total_stars

func set_level_scenes(scenes, keys):
	game["levels"] = scenes
	game["level_keys"] = keys
	for s in scenes:
		game["level_stars"].append(0)
	
func get_stars():
	return game["stars"]