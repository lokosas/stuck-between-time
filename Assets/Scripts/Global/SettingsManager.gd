extends Node

const SETTINGS_PATH = "user://settings.json"

var settings = {
	"fullscreen": DisplayServer.WINDOW_MODE_FULLSCREEN,
	"volume": 1.0, 
	"resolution": Vector2(1920, 1080)  # Example additional settings
}

func _ready():
	load_settings()

func load_settings():
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		
		if data:
			for key in data.keys():
				if key in settings:  # Only update known settings
					settings[key] = data[key]
	
	# Apply settings immediately
	apply_settings()

func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))  # Pretty print JSON
	file.close()

func apply_settings():
	DisplayServer.window_set_mode(settings["fullscreen"])
	# Example: Apply volume
	AudioServer.set_bus_volume_db(0, linear_to_db(settings["volume"]))
