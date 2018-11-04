tool
extends Area2D

const e = preload("res://scripts/enum.gd")

export (e.Items) var item = e.Items.JUMP setget set_item

func set_item(new_value):
	item = new_value
	if !has_node("label"):
		return
	match new_value:
		e.Items.JUMP:
			$label.set_text("jump")
		e.Items.PUSHER:
			$label.set_text("pusher")
		e.Items.GRAVITY_R:
			$label.set_text("rotate right")
		e.Items.GRAVITY_L:
			$label.set_text("rotate left")
		e.Items.GRAVITY_FLIP:
			$label.set_text("flip gravity")
		e.Items.LUNETTE:
			$label.set_text("lunette")
		e.Items.PLATFORM:
			$label.set_text("platform")
		_:
			$label.set_text("")

func _ready():
	connect("body_entered", self, "_on_item_body_entered")

func _on_item_body_entered(body):
	if body.has_method("collect"):
		body.collect(item)
		queue_free()
