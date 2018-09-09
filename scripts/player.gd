extends KinematicBody2D

export(float) var walk_speed = 300
export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export(float) var jump_force = 300

var grav_vel = 0
export var gravity = Vector2(0,1)

func _physics_process(delta):
	
	var linear_speed = Vector2()
	# add gravity
	if is_on_ceiling():
		grav_vel = grav_accel;
	if grav_vel < 0:
		print(grav_vel)
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel
	
	linear_speed += gravity*grav_vel
	
#	linear_speed.y += grav_accel;
#	linear_speed = move_and_slide(linear_speed,Vector2(0,-1))

	# process input
	var target_speed = 0
	if Input.is_action_pressed("right"):
		target_speed = 1
	elif Input.is_action_pressed("left"):
		target_speed = -1
	
	if Input.is_action_pressed("jump") and is_on_floor():
		grav_vel = -jump_force
	elif Input.is_action_just_released("jump") and !is_on_floor():
		grav_vel/=2;

	# add movement speed
	target_speed *= walk_speed
	linear_speed += gravity.rotated(3.141592*3/2)*target_speed
	
	move_and_slide(linear_speed, -gravity)
	
	
