extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var newtime_map = get_parent().get_node("Newtime")
@onready var oldtime_map = get_parent().get_node("Oldtime")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

	if Input.is_action_just_pressed("timeswap"):
		Global.oldTime = !Global.oldTime
		toggle_time()

func toggle_time():
	newtime_map.visible = not Global.oldTime
	oldtime_map.visible = Global.oldTime
	
	oldtime_map.set_process(Global.oldTime)
	newtime_map.set_process(not Global.oldTime)
