extends Node

# Changing scenes is most easily done using the functions `change_scene`
# and `change_scene_to` of the SceneTree. This script demonstrates how to
# change scenes without those helpers.

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)
	
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
