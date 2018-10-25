extends KinematicBody2D

# speed of the box motion when wakened
export(float) var wake_speed = 50
var awakened = false
var movement_speed = 0;
var movement_dir = Vector2();

func _physics_process(delta):
	if !awakened:
		return

	var linear_speed = Vector2()
	linear_speed += movement_dir*movement_speed
	
	set_collision_layer_bit(1,0)
	set_collision_mask_bit(1,0)
	var collide = test_move(transform, linear_speed*delta)
	if !collide:
		transform = transform.translated(linear_speed*delta)
	else:
		awakened = false
	set_collision_layer_bit(1,1)
	set_collision_mask_bit(1,1)
	
	

func move(direction, speed):
	movement_dir = direction;
	movement_speed = wake_speed
	awakened = true;