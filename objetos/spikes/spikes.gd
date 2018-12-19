extends Area2D


func _ready():
	connect("body_entered", self, "_on_area_entered")

func _on_area_entered(body):
	if body.has_method("kill"):
		body.kill(self);