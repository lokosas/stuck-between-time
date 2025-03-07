extends Area2D
class_name Projectile

var velocity = Vector2.ZERO
var downforce : int = 600
var pierces_walls : bool = false
var projectile_owner : Node2D

func _physics_process(delta):
	# Apply gravity to the velocity's Y component
	velocity.y += downforce * delta
	
	# Move the arrow
	position += velocity * delta

	# Rotate arrow in the direction of travel
	rotation = velocity.angle()


func _on_body_entered(body):
	if body.is_in_group("Map") and not pierces_walls:
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = 2.0
		attack.knockback_force = 200.0
		attack.attack_position = global_position # Set later when attacking
		attack.projectile_owner = projectile_owner

		hitbox.damage(attack)
