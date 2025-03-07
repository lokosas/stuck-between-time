extends Node2D
class_name HealthComponent

@export var maxHealth := 20.0
var health : float

func _ready():
	health = maxHealth

func damage(attack: Attack):
	if attack.projectile_owner == get_parent():
		return
	
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().queue_free()  # Destroy the enemy
	
	# Apply knockback to the parent (which should be CharacterBody2D)
	var parent = get_parent()
	if parent is CharacterBody2D:
		if parent.has_method("apply_knockback"):
			var knockback_direction = (global_position - attack.attack_position).normalized()
			parent.apply_knockback(knockback_direction * attack.knockback_force)
