extends Camera2D
export (NodePath) var object1
export (NodePath) var object2
var MIN_ZOOM_FACTOR = 1

func _ready():
	object1 = get_node(object1)
	object2 = get_node(object2)

func _process(_delta):
	self.global_position = (object1.global_position + object2.global_position) * 0.5

	var distanceX = abs(object1.global_position.x - object2.global_position.x)
	var distanceY = abs(object1.global_position.y - object2.global_position.y)

	var zoom_factor1 = (distanceX + 100) / (1920 - 100) + 1
	var zoom_factor2 = (distanceY + 100) / (1080 - 100) + 1
	var zoom_factor = max(max(zoom_factor1, zoom_factor2), MIN_ZOOM_FACTOR)

	self.zoom = Vector2(zoom_factor, zoom_factor)
