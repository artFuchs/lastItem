extends StaticBody2D


func _ready():
	$Area2D.connect("body_entered", self, "_on_area_entered")
	pass

func _on_area_entered(body):
	if body.has_method("kill"):
		body.kill();