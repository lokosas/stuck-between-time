extends CharacterBody2D


const walkspeed = 180.0
#const runspeed = 240
const jumpforce = -300.0
const maxFallSpeed = 400.0


@onready var newtime_map = get_parent().get_node("Newtime")
@onready var oldtime_map = get_parent().get_node("Oldtime")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var projectile = preload("res://projectile.tscn")

func _physics_process(delta):
	handle_gravity(delta)
	handle_actions()
	handle_movement()
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y = maxFallSpeed if velocity.y > maxFallSpeed else velocity.y + gravity * delta

func handle_actions():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		handle_jump()
	if Input.is_action_just_pressed("projectile"):
		spawn_projectile(0 if Global.oldTime else 1)
		
func handle_movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * walkspeed
	else:
		velocity.x = move_toward(velocity.x, 0, walkspeed)

func handle_jump():
	velocity.y = jumpforce

func spawn_projectile(type):
	
	var temp_projectile = projectile.instantiate()
	get_parent().add_child(temp_projectile)  # Add it to the main scene, not the player
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()  # Unit vector (keeps direction)
	var shoot_speed : float
	
	match type:
		0:
			shoot_speed = global_position.distance_to(mouse_pos) * 3  # Scale speed
			shoot_speed = clamp(shoot_speed, 180.0, 450.0)  # Clamp speed between 200 and 400
			temp_projectile.downforce = 600
			$ShootDelay.wait_time = 0.4
		1:
			shoot_speed = 500
			temp_projectile.downforce = 100
			$ShootDelay.wait_time = 0.1
	
	temp_projectile.global_position = global_position
	temp_projectile.velocity = direction * shoot_speed
	temp_projectile.rotation = temp_projectile.velocity.angle()
		
	if $ShootDelay.is_stopped() or $ShootDelay.time_left > $ShootDelay.wait_time:
		$ShootDelay.start()
	else:
		temp_projectile.queue_free()
	
