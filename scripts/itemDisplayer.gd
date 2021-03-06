extends HBoxContainer

const e = preload("res://scripts/enum.gd");

export(Texture) var default_tex = preload("res://sprites/square.png");
export(Array) var itemTextures;

func _ready():
	updateItems([])
	pass

func itemTexture(var item):
	var tex = default_tex
	if !item or (item > itemTextures.size()-1):
		tex = null
	else:
		tex = itemTextures[item]
	return tex;

func updateItems(var items):
	var textures = get_children();
	textures.pop_front(); #ignore the first child
	var firstItem = $actualItemFrame/TextureRect
	
	if items.empty():
		firstItem.texture = null
		for t in textures:
			t.texture = null
	else:
		firstItem.texture = itemTexture(items.pop_front())
		for t in textures:
			t.texture = itemTexture(items.pop_front())
			

func _on_player_changed_items(items):
	updateItems([]+items)
