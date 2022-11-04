extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
func change_poz():
	self.rect_position = Vector2(rng.randi_range(0, 11)*50, rng.randi_range(0, 13)*50)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
