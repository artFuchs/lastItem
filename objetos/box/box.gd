extends KinematicBody2D


export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export(bool) var fixed_speed
export(float) var wake_speed = 50
var gravity = Vector2(0,1)
var grav_vel = 0;

var movement_speed = 0;
export(int, 0, 100) var movement_decrease_tax = 1
var movement_dir = Vector2();


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
	
	if movement_speed > 0:
		movement_speed -= movement_decrease_tax
	elif movement_speed < 0:
		movement_speed = 0;
	linear_speed += movement_dir*movement_speed;
	
	move_and_slide(linear_speed, -gravity);
	
	if is_on_wall():
		movement_speed = 0;

func move(direction, speed):
	movement_dir = direction;
	if fixed_speed:
		movement_speed = wake_speed
	else:
		movement_speed = speed
