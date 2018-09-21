extends StaticBody2D

func _ready():
	pass

func _physics_process(delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		print("collision")
		if collider.has_method("kill"):
			collider.kill()