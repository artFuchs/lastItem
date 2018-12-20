extends Path2D

var tween
var dir = false
var changeDir = false

func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)

	tween.interpolate_property($PathFollow2D, "unit_offset", 0, 1, 7, tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	
	tween.set_repeat(true)
	tween.start()

#func _process(delta):

	#print($PathFollow2D.unit_offset)
