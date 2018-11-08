extends KinematicBody2D

export var motion = Vector2();

func _physics_process(delta):
	var collision = move_and_collide(motion*delta);
	if collision:
		var other = collision.collider
		if other.has_method("move"):
			other.move(motion.normalized(), motion.length());
		queue_free();
		
func flip():
	$Sprite2.flip_h = !$Sprite2.flip_h;
	$Sprite.flip_h = !$Sprite.flip_h;

