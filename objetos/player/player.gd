extends KinematicBody2D

enum States{
	NORMAL,
	PLATFORM,
	LUNETTE,
	STOPED,
}
var state = States.NORMAL

const e = preload("res://scripts/enum.gd")
var items = []
var bullet = preload("res://objetos/bullet/bullet.tscn");
var bulletSpeed = 200;

export(float) var walk_speed = 300
export(float) var grav_accel = 10
export(float) var max_grav_vel = 300
export(float) var jump_force = 300
export var gravity = Vector2(0,1)

var grav_vel = 0
var r = true # true se o player está virado para direita

export (Texture) var PlatformTex;
export (PackedScene) var platform
var platform_collisions = [false,false,false,false]

signal killed
signal changed_items(items)

func _physics_process(delta):
	
	match state:
		States.NORMAL:
			process_normal(delta)
		States.PLATFORM:
			process_platform(delta)
		States.LUNETTE:
			process_lunette(delta)
			
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
				
			draw_texture(PlatformTex, Vector2(0.5*w,-0.5*h), colors[0])
			draw_texture(PlatformTex, Vector2(-1.5*w,-0.5*h), colors[1])
			draw_texture(PlatformTex, Vector2(-0.5*w,-1.5*h), colors[2])
			draw_texture(PlatformTex, Vector2(-0.5*w,0.5*h), colors[3])
		

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
		state = States.NORMAL
	
func process_platform(delta):
	var w = PlatformTex.get_width()
	var h = PlatformTex.get_height()
	platform_collisions[0] = test_move(transform, w*gravity.rotated(3.1415*1.5)) # right
	platform_collisions[1] = test_move(transform, w*gravity.rotated(3.1415*0.5)) # left
	platform_collisions[2] = test_move(transform, h*gravity.rotated(-3.1415)) # up
	platform_collisions[3] = test_move(transform, h*gravity) # down
	update()
	
	if Input.is_action_just_pressed("item"): #cancel
		state = States.NORMAL
		items.push_front(e.Items.PLATFORM)
		emit_signal("changed_items", items)
		update()
	
	if Input.is_action_just_pressed("right") and !platform_collisions[0]:
		create_platform(Vector2(w, 0))
		state = States.NORMAL
		update()
		
	if Input.is_action_just_pressed("left") and !platform_collisions[1]:
		create_platform(Vector2(-w, 0))
		state = States.NORMAL
		update()
	
	if Input.is_action_just_pressed("jump") and !platform_collisions[2]:
		create_platform(Vector2(0, -h))
		state = States.NORMAL
		update()
	
	if Input.is_action_just_pressed("down") and !platform_collisions[3]:
		create_platform(Vector2(0, h))
		state = States.NORMAL
		update()
	
func jump():
	grav_vel = -jump_force;
	
func use_item():
	if items.empty():
		return
	
	match items.pop_front():
		e.Items.JUMP:
			jump()
		e.Items.PUSHER:
			shot_pusher()
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
		e.Items.PLATFORM:
			state = States.PLATFORM
			update()
		_:
			pass
			
	emit_signal("changed_items", items)
	
func shot_pusher():
	var b = bullet.instance();
	get_parent().add_child(b)
	if r:
		b.position = to_global($pos_r.position)
		b.motion = gravity.rotated(3.141592*3/2)
	else:
		b.position = to_global($pos_l.position)
		b.motion = gravity.rotated(3.141592*1/2)
	b.motion*= bulletSpeed
	
func create_platform(pos):
	if !platform:
		return
	var p = platform.instance()
	get_parent().add_child(p)
	p.position = to_global(pos)
	
func collect(item):
	if item >= e.Items.JUMP and item <= e.Items.PLATFORM:
		items.append(item)
		emit_signal("changed_items", items)

func kill():
	emit_signal("killed")
	queue_free()
	
func _input_event(viewport, event, shape_idx):
	kill()
