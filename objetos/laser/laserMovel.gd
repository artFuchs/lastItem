extends Path2D

var tween
var dir = false
var changeDir = false
export(int) var duration = 7

func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)

	tween.interpolate_property($PathFollow2D, "unit_offset", 0, 1, duration, tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	
	tween.set_repeat(true)
	tween.start()

#func _process(delta):

	#print($PathFollow2D.unit_offset)
