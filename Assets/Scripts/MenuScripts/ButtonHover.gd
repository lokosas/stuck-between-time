extends Button

@onready var label = $Label # Adjust if your button has a custom label node
@export var distance = 8

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	label.position.y += distance  # Move text down

func _on_mouse_exited():
	label.position.y -= distance  # Reset position
