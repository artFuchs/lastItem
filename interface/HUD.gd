extends VBoxContainer

onready var pointsLabel = $pointsDisplayer/number
onready var itemDisplayer = $itemDisplayer

func _ready():
	pointsLabel.set_text("0")
	
func updateItems(items):
	itemDisplayer.updateItems(items)
	
func updatePoints(points):
	pointsLabel.set_text(str(points))
