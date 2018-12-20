extends KinematicBody2D

enum States{
	NORMAL,
	PLATFORM,
	LUNETTE,
	PUSHING,
	DEAD
}

enum Killer{
	FALL,
	SPIKES,
	LASER
}
var state = States.NORMAL

const e = preload("res://scripts/enum.gd")
var items = []

export var bullet = preload("res://objetos/bullet/bullet.tscn");
var bulletSpeed = 200;

var camera_zoom # zoom normal da camera
var lunette_zoom = Vector2(1.5,1.5)

export(float) var walk_speed = 300
export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export(float) var jump_force = 300
export var gravity = Vector2(0,1)

var grav_vel = 0

onready var sprite = $Sprite
var r = true # true se o player está virado para direita

var anim = ""
var walking = false

export (Texture) var PlatformTex;
export (PackedScene) var platform
export var p_dist= 8; #platform_distance
var platform_collisions = [false,false,false,false]
export var platform_time = 5
var actual_platform_time = 0;

# state DEAD
var rot = 0;
var deadtravel = 0;
var killer = Killer.SPIKES

# sounds
export (AudioStreamSample) var jumpFX;
export (AudioStreamSample) var platformFX;
export (AudioStreamSample) var itemCollectFX;


signal killed
signal changed_items(items)

func _ready():
	camera_zoom = $Camera2D.zoom;

func _physics_process(delta):
	match state:
		States.NORMAL:
			process_normal(delta)
		States.PLATFORM:
			process_platform(delta)
		States.LUNETTE:
			process_lunette(delta)
		States.DEAD:
			process_dead(delta)
			
	if r:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	# animações
	var new_animation = "idle";
	
	if state == States.PUSHING:
		if is_on_floor():
			new_animation = "push";
		else:
			new_animation = "air_push";
	elif state == States.NORMAL:
		if is_on_floor():
			if walking:
				new_animation = "walking";
		else:
			if grav_vel > 100:
				new_animation = "falling";
			elif grav_vel < -100:
				new_animation = "jump";
			else:
				new_animation = "air_neutral";
	elif state == States.PLATFORM:
		new_animation = "plat"
	elif state == States.DEAD:
		if killer == Killer.FALL:
			new_animation = "fall"
		elif killer == Killer.SPIKES:
			new_animation = "dead"
		else:
			new_animation = "dead_elet"
	elif state == States.LUNETTE:
		new_animation = "plat"
	
	if new_animation!=anim:
		anim = new_animation
		$AnimationPlayer.play(anim)	
		
	
			
func _draw():
	match state:
		States.NORMAL:
			pass
		States.PLATFORM:
			var w = PlatformTex.get_width()
			var h = PlatformTex.get_height()
			var white = Color(1,1,1,0.5)
			var red = Color(1,0,0,0.5)
			var colors = [white, white, white, white]
			for i in range(0,platform_collisions.size()):
				if platform_collisions[i]:
					colors[i] = red
				else:
					colors[i] = white
				
			draw_texture(PlatformTex, Vector2(0.5*w + p_dist,-0.5*h), colors[0]) # right
			draw_texture(PlatformTex, Vector2(-1.5*w - p_dist,-0.5*h), colors[1]) # left
			draw_texture(PlatformTex, Vector2(-0.5*w,-1.5*h - p_dist), colors[2]) # up
			draw_texture(PlatformTex, Vector2(-0.5*w,0.5*h + p_dist), colors[3]) # down
			draw_circle(Vector2(0,0), w*(actual_platform_time/platform_time), white)
		
func process_normal(delta):
	var linear_speed = Vector2()
	# update gravity
	if is_on_ceiling():
		grav_vel = grav_accel
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel
	if is_on_floor():
		grav_vel = grav_accel
		
	# processar entrada
	# movimento
	var target_speed = 0
	if Input.is_action_pressed("right"):
		target_speed = 1
		r = true
	elif Input.is_action_pressed("left"):
		target_speed = -1
		r = false
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump();
	elif Input.is_action_just_released("jump") and !is_on_floor() and grav_vel<0:
		grav_vel/=2;
	
	# ação
	if Input.is_action_just_pressed("item"):
		use_item()
	
	# adicionar gravidade e velocidade de movimento
	linear_speed += gravity*grav_vel
	target_speed *= walk_speed
	linear_speed += gravity.rotated(3.141592*3/2)*target_speed
	
	# mover
	move_and_slide(linear_speed, -gravity)
	
	# atualizar informações para animação
	if (target_speed != 0 and is_on_floor()):
		walking = true;
	else:
		walking = false;

func process_lunette(delta):
	var d = 16;
	
	if Input.is_action_pressed("right"):
		$Camera2D.position.x += d
	elif Input.is_action_pressed("left"):
		$Camera2D.position.x -= d
		
	if Input.is_action_pressed("jump"):
		$Camera2D.position.y -= d
	elif Input.is_action_pressed("down"):
		$Camera2D.position.y += d
	
	if Input.is_action_just_pressed("item"):
		$Camera2D.transform = Transform()	
		$Camera2D.set_zoom(camera_zoom)
		state = States.NORMAL

func process_platform(delta):
	if actual_platform_time > 0:
		var w = PlatformTex.get_width()
		var h = PlatformTex.get_height()
		platform_collisions[0] = test_move(transform, (p_dist+w)*gravity.rotated(3.1415*1.5)) # right
		platform_collisions[1] = test_move(transform, (p_dist+w)*gravity.rotated(3.1415*0.5)) # left
		platform_collisions[2] = test_move(transform, (p_dist+h)*gravity.rotated(-3.1415)) # up
		platform_collisions[3] = test_move(transform, (p_dist+h)*gravity) # down
		
		if Input.is_action_just_pressed("item"): #cancel
			state = States.NORMAL
			items.push_front(e.Items.PLATFORM)
			emit_signal("changed_items", items)
		
		if Input.is_action_just_pressed("right") and !platform_collisions[0]:
			create_platform(Vector2(p_dist+w, 0))
			state = States.NORMAL
			
		if Input.is_action_just_pressed("left") and !platform_collisions[1]:
			create_platform(Vector2(-p_dist-w, 0))
			state = States.NORMAL
		
		if Input.is_action_just_pressed("jump") and !platform_collisions[2]:
			create_platform(Vector2(0, -p_dist-h))
			state = States.NORMAL
		
		if Input.is_action_just_pressed("down") and !platform_collisions[3]:
			create_platform(Vector2(0, p_dist+h))
			state = States.NORMAL
			
		actual_platform_time -= delta
		update()
	else:
		state = States.NORMAL
		update()


func process_dead(delta):
	if killer == Killer.SPIKES:
		if rot == 0:
			rot = rand_range(-30,30)
			grav_vel = rand_range(-150, -10)
		sprite.rotation += rot*delta;
			
	if killer == Killer.SPIKES or killer == Killer.FALL:
		grav_vel += grav_accel
		position += gravity*grav_vel*delta
		deadtravel += grav_vel*delta
		if deadtravel > 400:
			emit_signal("killed")
			queue_free()
	
	if killer == Killer.LASER:
		sprite.modulate = Color(1,1,1)
		deadtravel += delta
		if deadtravel > 2:
			emit_signal("killed")
			queue_free()
		
		
	
		
func jump():
	grav_vel = -jump_force;
	if not $AudioPlayer.playing:
		$AudioPlayer.set_stream(jumpFX)
		$AudioPlayer.play()
	
func use_item():
	if items.empty():
		return
	
	match items.pop_front():
		e.Items.JUMP:
			jump()
		e.Items.PUSHER:
			state = States.PUSHING
		e.Items.GRAVITY_R:
			gravity = gravity.rotated(3.141592*3/2)
			self.rotate(3.141592*3/2)
		e.Items.GRAVITY_L:
			gravity = gravity.rotated(3.141592*1/2)
			self.rotate(3.141592*1/2)
		e.Items.GRAVITY_FLIP:
			gravity = -gravity
			self.rotate(3.141592)
		e.Items.LUNETTE:
			state = States.LUNETTE
			$Camera2D.set_zoom(lunette_zoom)
		e.Items.PLATFORM:
			state = States.PLATFORM
			actual_platform_time = platform_time
			update()
		_:
			pass
			
	emit_signal("changed_items", items)
	
func shot_pusher():
	var b = bullet.instance();
	get_parent().add_child(b)
	b.rotation = self.rotation
	if r:
		b.position = to_global($pos_r.position)
		b.motion = gravity.rotated(3.141592*3/2)
	else:
		b.position = to_global($pos_l.position)
		b.motion = gravity.rotated(3.141592*1/2)
		b.flip();
	b.motion*= bulletSpeed
	
func create_platform(pos):
	if !platform:
		return
	var p = platform.instance()
	get_parent().add_child(p)
	p.position = to_global(pos)
	$AudioPlayer.set_stream(platformFX)
	$AudioPlayer.play()
	
func collect(item):
	if item >= e.Items.JUMP and item <= e.Items.PLATFORM:
		items.append(item)
		emit_signal("changed_items", items)
		$AudioPlayer.set_stream(itemCollectFX)
		$AudioPlayer.play()

func kill(killerobj = null):
	if state != DEAD:
		state = DEAD
		var camera = $Camera2D
		remove_child(camera)
		var camPos = camera.position
		get_parent().add_child(camera)
		camera.position = to_global(camPos)
		$CollisionShape2D.disabled = true;
		
		if !killerobj:
			killer = Killer.SPIKES
		elif killerobj.is_in_group("boundary"):
			killer = Killer.FALL
		elif killerobj.is_in_group("spikes"):
			killer = Killer.SPIKES
		elif killerobj.is_in_group("laser"):
			killer = Killer.LASER
			
	
func set_state(s):
	state = s;
