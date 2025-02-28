extends Node2D


@onready var og_newtime_pos = $Newtime.position
@onready var og_oldtime_pos = $Oldtime.position

func _ready():
	toggle_time()
	
func _process(delta):
	if Input.is_action_just_pressed("timeswap"):
		Global.oldTime = !Global.oldTime
		toggle_time()

func toggle_time():
	#$Newtime.visible = not Global.oldTime
	#$Oldtime.visible = Global.oldTime
	
	if Global.oldTime:
		$Oldtime.position.y = -2000
		$Newtime.position.y = og_newtime_pos.y  # Bring the new map back
	else:
		$Newtime.position.y = -2000
		$Oldtime.position.y = og_oldtime_pos.y
