extends CharacterBody2D


const walkspeed = 180.0
#const runspeed = 240
const jumpforce = -300.0


@onready var newtime_map = get_parent().get_node("Newtime")
@onready var oldtime_map = get_parent().get_node("Oldtime")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpforce

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * walkspeed
	else:
		velocity.x = move_toward(velocity.x, 0, walkspeed)
	move_and_slide()

