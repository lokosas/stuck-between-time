extends Node2D

func _ready():
	toggle_time()
	
func _process(delta):
	if Input.is_action_just_pressed("timeswap"):
		Global.oldTime = !Global.oldTime
		toggle_time()

func toggle_time():
	$Newtime.visible = not Global.oldTime
	$Oldtime.visible = Global.oldTime
	$Newtime.collision_enabled = not Global.oldTime
	$Oldtime.collision_enabled = Global.oldTime
