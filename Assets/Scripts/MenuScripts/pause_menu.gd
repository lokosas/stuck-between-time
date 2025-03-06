extends Control

func _ready():
	unpause()

func pause():
	get_tree().paused = true
	visible = true
	
func unpause():
	get_tree().paused = false
	visible = false

func _input(event):
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func _on_resume_pressed():
	unpause()

func _on_settings_pressed():
	pass # Replace with function body.


func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
