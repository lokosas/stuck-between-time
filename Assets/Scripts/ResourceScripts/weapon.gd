extends Node2D

var attack_damage := 2.0
var knockback_force := 100.0
var weapon_type = 1
var timer : Timer
var attack_time := 0.1
var attacking = false
var attack_distance := 25.0 # Distance from the player to the attack position
var projectile : PackedScene = preload("res://Assets/Scenes/ResourceScenes/projectile.tscn") # Change to your actual projectile scene path
var weapon_switch_cooldown = false

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position # Set later when attacking

		hitbox.damage(attack)
		
func _ready():
	timer = $AttackDelay
	timer.timeout.connect(disable_attacking)
	disable_attacking()

func disable_attacking():
	$Hitbox/CollisionShape2D.disabled = true
	visible = false
	
func enable_attacking():
	var mouse_position = get_global_mouse_position()
	var attack_direction = (mouse_position - get_parent().global_position).normalized()
	
	# Offset based on player's position instead of the weapon itself
	var attack_position = get_parent().global_position + attack_direction * attack_distance
	
	$Hitbox.global_position = attack_position
	$Hitbox.rotation = attack_direction.angle()
	
	# Enable attack
	$Hitbox/CollisionShape2D.disabled = false
	visible = true
	timer.start(attack_time)

func spawn_projectile():
	var temp_projectile = projectile.instantiate()
	get_tree().root.add_child(temp_projectile)
	
	temp_projectile.projectile_owner = get_parent()

	var mouse_pos = get_global_mouse_position() + Vector2(0, -32)
	var direction = (mouse_pos - global_position).normalized()
	var shoot_speed = 500.0
	
	match Global.oldTime:
		true:
			shoot_speed = clamp(global_position.distance_to(mouse_pos) * 3.5, 180.0, 500.0)
			temp_projectile.downforce = 900
		false:
			shoot_speed = 500.0
			temp_projectile.downforce = 100
	
	temp_projectile.global_position = global_position + Vector2(-attack_distance/2, 0)

	temp_projectile.velocity = direction * shoot_speed
	temp_projectile.rotation = temp_projectile.velocity.angle()

func _unhandled_input(event):
	if event.is_action_pressed("next_weapon") and not weapon_switch_cooldown:
		weapon_type = (weapon_type + 1) % 2
		weapon_switch_cooldown = true  # Lock the switch until released

	if not event.is_action_pressed("next_weapon"):
		weapon_switch_cooldown = false  # Release lock when button is released
		
	if event.is_action_pressed("projectile"):
		match weapon_type:
			0:
				enable_attacking()
			1:
				spawn_projectile()
