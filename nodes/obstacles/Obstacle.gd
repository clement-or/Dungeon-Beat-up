extends StaticBody2D

func _ready():
	pass


func _on_Hitbox_body_entered(body):
	if body.get_name() == "Player":
		body.stun()
		queue_free()
