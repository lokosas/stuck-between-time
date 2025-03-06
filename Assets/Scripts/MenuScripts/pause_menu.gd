extends Control

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false


func _input(event):
	if event.is_action_pressed("esc") and get_tree().paused:
		pause()

	if event.is_action_pressed("esc") and get_tree().paused:
		unpause()
