tool
extends Area2D

const e = preload("res://scripts/enum.gd")

export (e.Items) var item = e.Items.JUMP setget set_item

func set_item(new_value):
	item = new_value
	var label = get_node("label");
	if !label:
		return
	match new_value:
		e.Items.JUMP:
			label.set_text("jump")
		e.Items.PUSHER:
			label.set_text("pusher")
		e.Items.GRAVITY_R:
			label.set_text("rotate right")
		e.Items.GRAVITY_L:
			label.set_text("rotate left")
		e.Items.GRAVITY_FLIP:
			label.set_text("flip gravity")
		e.Items.CANNON:
			label.set_text("cannon")
		e.Items.PLATFORM:
			label.set_text("platform")

func _ready():
	connect("body_entered", self, "_on_item_body_entered")

func _on_item_body_entered(body):
	if body.has_method("collect"):
		body.collect(item)
		queue_free()
