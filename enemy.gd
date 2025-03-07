extends CharacterBody2D

func apply_knockback(knockback_vector: Vector2):
	print(knockback_vector)
	velocity = knockback_vector
	move_and_slide()
