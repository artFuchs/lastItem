extends StaticBody2D

var active = false
signal actived(active)

func _ready():
	active = false
	
func switch():
	active = !active
	emit_signal("actived", active)
	$Sprite.frame = int(active)

func move(a,b):
	switch()