extends Node2D

var attack_damage := 2.0
var knockback_force := 100.0

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position

		
		hitbox.damage(attack)
var timer : Timer
var attack_time := 0.6


func _ready():
	timer = $AttackDelay
