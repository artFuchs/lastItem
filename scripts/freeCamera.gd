extends Camera2D

export var step = 500

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("down"):
		position.y += step*delta
	if Input.is_action_pressed("jump"):
		position.y -= step*delta
	if Input.is_action_pressed("right"):
		position.x += step*delta
	if Input.is_action_pressed("left"):
		position.x -= step*delta
