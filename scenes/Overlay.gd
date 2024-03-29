extends SubViewportContainer

@onready var Overlay = get_parent().find_child("Overlay")
@onready var Continue = get_parent().find_child("Continue")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	Overlay.set_visible(false)
	Continue.set_visible(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_button_pressed():
	get_tree().quit()
