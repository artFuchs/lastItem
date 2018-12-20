extends StaticBody2D

export(bool) var laserDefect = false
export(float) var timeOn = 1
export(float) var timeOff = 1
var laserOn = true



func _ready():
	pass

func _physics_process(delta):
	if laserOn:
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider:
				if collider.has_method("kill"):
					collider.kill(self)
			$Line2D.points[1].y = to_local($RayCast2D.get_collision_point()).y