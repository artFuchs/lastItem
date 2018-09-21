extends KinematicBody2D

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
var r = true

signal killed
signal changed_items


func _physics_process(delta):
	
	var linear_speed = Vector2()
	
	# update gravity
	if is_on_ceiling():
		grav_vel = grav_accel;
	grav_vel += grav_accel
	if grav_vel > max_grav_vel:
		grav_vel = max_grav_vel;
	if is_on_floor():
		grav_vel = grav_accel;

	# process input
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
	
	if Input.is_action_just_pressed("item"):
		use_item()
	
	# add gravity and movement speed
	linear_speed += gravity*grav_vel
	target_speed *= walk_speed
	linear_speed += gravity.rotated(3.141592*3/2)*target_speed
	
	move_and_slide(linear_speed, -gravity)
	
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
		_:
			pass
			
	emit_signal("changed_items")
	
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
	
func collect(item):
	if item >= e.Items.JUMP and item <= e.Items.PLATFORM:
		items.append(item)
	emit_signal("changed_items")

func kill():
	emit_signal("killed")
	queue_free()
	
func _input_event(viewport, event, shape_idx):
	kill()
