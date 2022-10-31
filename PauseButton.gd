extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _pressed():
	var timer = get_parent().get_parent().get_node("Timer")
	if timer.is_stopped():
		timer.start()
	else:
		timer.stop()
	var pauseMenu = get_parent().get_parent().get_node("PauseMenu")
	pauseMenu.visible = !pauseMenu.visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
