extends Area2D

signal level_end;

func _ready():
	connect("body_entered", self, "_on_flag_body_entered")

func _on_flag_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("level_end")