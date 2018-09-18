extends KinematicBody2D

# class member variables go here, for example:
export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
var gravity = Vector2(0,1)
var grav_vel = 0;

func _physics_process(delta):
	
	var linear_speed = Vector2()
	
	if is_on_ceiling():
		grav_vel = grav_accel;
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel;
	if is_on_floor():
		grav_vel = 0;
	
	linear_speed += gravity*grav_vel;
	
	move_and_slide(linear_speed, -gravity)	
