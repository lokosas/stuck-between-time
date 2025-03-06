extends Node

var oldTime := true

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		# Toggle fullscreen mode
		var is_fullscreen = SettingsManager.settings["fullscreen"] == DisplayServer.WINDOW_MODE_FULLSCREEN
		SettingsManager.settings["fullscreen"] = DisplayServer.WINDOW_MODE_WINDOWED if is_fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN
		
		# Apply & save settings
		SettingsManager.apply_settings()
		SettingsManager.save_settings()
