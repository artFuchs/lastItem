extends StaticBody2D

export(float) var timeOn = 1
export(float) var timeOff = 1
var laserOn = true

func _ready():
	$timerOn.set_wait_time(timeOn)
	$timerOff.set_wait_time(timeOff)
	$timerOn.start()

func _physics_process(delta):
	if laserOn:
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider:
				if collider.has_method("kill"):
					collider.kill(self)
			$Line2D.points[1].y = to_local($RayCast2D.get_collision_point()).y

func _on_timerOn_timeout():
	laserOn = false
	$Line2D.hide()
	$Line2D2.hide()
	$Line2D3.hide()
	$timerOff.start()

func _on_timerOff_timeout():
	laserOn = true
	$Line2D.show()
	$Line2D2.show()
	$Line2D3.show()
	$timerOn.start()