extends KinematicBody2D

export(float,50,300) var fov = 200
export(float) var walk_speed = 150
export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export(Vector2) var gravity = Vector2(0,1)
var min_distance = 10;
var grav_vel = 0
var r = true
var walking = true
var running = false
var can_walk = true;

func _ready():
	var ray_dest = Vector2(fov,0);
	if !r:
		ray_dest = Vector2(-fov,0);
	$RayCast2D.cast_to = ray_dest
	pass

func _physics_process(delta):
	var linear_speed = Vector2()
	# update gravity
	if is_on_ceiling():
		grav_vel = grav_accel
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel
	if is_on_floor():
		grav_vel = grav_accel
		
	# inteligencia
	_process_IA()
		
	# movimento
	var target_speed = 0
	if running:
		target_speed = 2
	elif walking:
		target_speed = 1
		
	if !r:
		target_speed *= -1
	
	# adicionar gravidade e velocidade de movimento
	linear_speed += gravity*grav_vel
	target_speed *= walk_speed
	linear_speed += gravity.rotated(3.141592*3/2)*target_speed
	
	#debugging
#	var text = "walking: " + str(walking) + "\n"
#	text += "running: " + str(running) + "\n"
#	text += "r: " + str(r) + "\n"
#	text += "linear_speed: " + str(linear_speed) + "\n"
#	$Label.set_text(text)
	
	# mover
	var mov = move_and_slide(linear_speed, -gravity)
	if mov.length() == 0:
		for i in get_slide_count():
			var col = get_slide_collision(i).get_collider();
			if col.is_in_group("player"):
				col.kill()
	
	# animacoes
	_process_animations()

onready var ray = $RayCast2D
func _process_IA():
	if ray.is_colliding():
		var observed = ray.get_collider()
		if (observed):
			if (observed.is_in_group("player")):
				running = true;
			elif walking:
				var distance_to_observed = ray.global_position.distance_to(ray.get_collision_point())
				if (distance_to_observed < min_distance):
					if running:
						turn()
					else:
						wait()
			elif can_walk:
				walking = true

func wait():
	walking = false
	can_walk = false
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.connect("timeout",self,"_on_wait_end");
	t.start()

func _on_wait_end():
	for c in get_children():
		if c.is_class("Timer"):
			c.queue_free();
	turn();
	$AudioPlayer.play();

func turn():
	r = !r
	ray.rotate(deg2rad(180));
	can_walk = true
	running = false

onready var sprite = $AnimatedSprite
func _process_animations():
	if r:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	var animation = "standing"
	var animation_speed = 5
	
	if running:
		animation = "running"
		animation_speed = 5
		$Particles2D.emitting = true
	elif walking:
		animation = "walking"
		$Particles2D.emitting = false
	else:
		$Particles2D.emitting = false
		
	if sprite.get_animation() != animation:
		sprite.play(animation)
		sprite.frames.set_animation_speed(animation, animation_speed)
	
	
	
	
	