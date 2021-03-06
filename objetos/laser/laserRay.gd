extends StaticBody2D

func _ready():
	pass

func _physics_process(delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider:
			if collider.has_method("kill"):
				collider.kill(self)
		$Line2D.points[1].y = to_local($RayCast2D.get_collision_point()).y