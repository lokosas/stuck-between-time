extends Area2D

var velocity = Vector2.ZERO

const downforce = 600

func _physics_process(delta):
	# Apply gravity to the velocity's Y component
	velocity.y += downforce * delta
	
	# Move the arrow
	position += velocity * delta

	# Rotate arrow in the direction of travel
	rotation = velocity.angle()


func _on_body_entered(body):
	queue_free()


func _on_timer_timeout():
	queue_free()
