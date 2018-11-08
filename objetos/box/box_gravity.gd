extends "res://objetos/box/box.gd"

export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export var gravity = Vector2(0,1)
var grav_vel = 0;

func _ready():
	awakened = true;

func _physics_process(delta):
	
	var linear_speed = Vector2()
	
	# adicionar gravidade
	if is_on_ceiling():
		grav_vel = grav_accel
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel
	if is_on_floor():
		grav_vel = 0;
	else:
		awakened = true
	
	if awakened:	
		linear_speed += gravity*grav_vel;
		
		# adicionar movimento
		
		if movement_speed < 0:
			movement_speed = 0;
		
		linear_speed += movement_dir*movement_speed;
	
	
		var motion = move_and_slide(linear_speed, -gravity);
		if motion == Vector2():
			awakened = false
			$Sprite.frame = 0
	
		if is_on_wall():
			movement_speed = 0;
