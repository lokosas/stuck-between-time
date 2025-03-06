extends CharacterBody2D

const WALK_SPEED = 180.0
const RUN_SPEED = 240.0
const JUMP_FORCE = -300.0
const MAX_FALL_SPEED = 400.0

var hold_time_proj = 0.0
var charging_proj = false
var is_running = false

var can_dash = true
var is_dashing = false
var dash_speed = 600.0
var dash_length = 0.18
var dash_remain = 0.0

@onready var newtime_map = get_parent().get_node("Newtime")
@onready var oldtime_map = get_parent().get_node("Oldtime")
@onready var projectile = preload("res://projectile.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	handle_gravity(delta)
	handle_actions(delta)
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)

func handle_actions(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		handle_jump()
	handle_proj_charge(delta)
	handle_movement()
	handle_dashing(delta)

func handle_movement():
	if not is_dashing:
		is_running = Input.is_action_pressed("run")
		var direction = Input.get_axis("left", "right")
		
		if direction:
			velocity.x = direction * (RUN_SPEED if is_running else WALK_SPEED)
		elif not is_dashing:
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED if is_running else WALK_SPEED)

func handle_jump():
	velocity.y = JUMP_FORCE
	
func handle_dashing(delta):
	if Input.is_action_just_pressed("dash") and $DashDelay.is_stopped() and not dash_remain > dash_length:
		is_dashing = true
		
	if is_dashing:
		var direction_x = Input.get_axis("left", "right")
		var direction_y = Input.get_axis("ui_down", "up")  # Allows dashing up if desired

		velocity.x = direction_x * dash_speed
		velocity.y = direction_y * dash_speed * -1  # Negative to go up in 2D
		dash_remain += delta
		
	if is_dashing and dash_remain > dash_length:
		is_dashing = false

	if dash_remain > dash_length and is_on_floor():
		dash_remain = 0.0
		$DashDelay.start()

func handle_proj_charge(delta):
	if charging_proj:
		hold_time_proj += delta
	
	if Input.is_action_just_pressed("projectile"):
		hold_time_proj = 0.0
		charging_proj = true
	
	if Input.is_action_just_released("projectile"):
		charging_proj = false
		spawn_projectile(0 if Global.oldTime else 1, hold_time_proj)

func spawn_projectile(type, charge):
	var temp_projectile = projectile.instantiate()
	get_parent().add_child(temp_projectile)
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var shoot_speed = 500.0
	
	match type:
		0:
			shoot_speed = clamp(global_position.distance_to(mouse_pos) * 3, 180.0, 450.0)
			temp_projectile.downforce = 800
		1:
			shoot_speed = 500.0
			temp_projectile.downforce = 100
	
	temp_projectile.global_position = global_position
	temp_projectile.velocity = direction * shoot_speed
	temp_projectile.rotation = temp_projectile.velocity.angle()
