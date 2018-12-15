extends Path2D

var opened = false
export var step = 0.2
export (NodePath) var switch_path
var switchObj

func _ready():
	if switch_path:
		switchObj = get_node(switch_path)
		switchObj.connect("actived", self, "_on_switch_actived")
	

onready var follow = $PathFollow2D
func _process(delta):
	if opened:
		if follow.unit_offset < 1:
			follow.unit_offset += delta*step
	else:
		if follow.unit_offset > 0:
			follow.unit_offset -= delta*step

func _on_switch_actived(active):
	opened = active