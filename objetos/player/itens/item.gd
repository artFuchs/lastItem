tool
extends Area2D

const e = preload("res://scripts/enum.gd")

export (e.Items) var item = e.Items.JUMP setget set_item
export (Array) var textures = []
var color

func set_item(new_value):
	item = new_value
	if !has_node("liquido") or !has_node("balao") or textures.size()==0 :
		return
	var c = Color("ffffff");
	match new_value:
		e.Items.JUMP:
			#$label.set_text("jump")
			c = Color("d100b2")
		e.Items.PUSHER:
			#$label.set_text("pusher")
			c = Color("ff0000")
		e.Items.GRAVITY_R:
			#$label.set_text("rotate right")
			c = Color("008000")
		e.Items.GRAVITY_L:
			#$label.set_text("rotate left")
			c = Color("a0a200ff")
		e.Items.GRAVITY_FLIP:
			#$label.set_text("flip gravity")
			c = Color("0000ff")
		e.Items.LUNETTE:
			#$label.set_text("lunette")
			c = Color("000931")
		e.Items.PLATFORM:
			#$label.set_text("platform")
			c = Color("ff5500")
		_:
			#$label.set_text("")
			pass
	$liquido.modulate = c
	$balao.self_modulate = c
	$balao/Sprite.texture = textures[item]

func _ready():
	connect("body_entered", self, "_on_item_body_entered")

func _on_item_body_entered(body):
	if body.has_method("collect"):
		body.collect(item)
		queue_free()
