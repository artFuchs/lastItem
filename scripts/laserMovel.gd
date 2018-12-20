extends Path2D

var tween
var dir = false
var changeDir = false
export(int) var duration = 2

func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)

	tween.interpolate_property($PathFollow2D, "unit_offset", 0, 1, duration, 0, tween.EASE_IN_OUT)
	#tween.interpolate_property($PathFollow2D, "unit_offset",
	
	tween.set_repeat(true)
	tween.start()

func _process(delta):
	print($PathFollow2D.unit_offset)
