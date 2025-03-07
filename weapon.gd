extends Node2D

var attack_damage := 2.0
var knockback_force := 100.0
var weapon_type = 0
var timer : Timer
var attack_time := 0.1
var attacking = false
var attack_distance := 20.0 # Distance from the player to the attack position

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
	# Get mouse position relative to the world
	var mouse_position = get_global_mouse_position()
	# Get direction from the player to the mouse
	var attack_direction = (mouse_position - global_position).normalized()
	# Offset the attack position
	$Hitbox.global_position = global_position + attack_direction * attack_distance
	$Hitbox.rotation = (get_global_mouse_position() - global_position).angle()
	# Enable attack
	$Hitbox/CollisionShape2D.disabled = false
	visible = true
	timer.start(attack_time)

func _input(event):
	if event.is_action_pressed("projectile"):
		match weapon_type:
			0:
				enable_attacking()
