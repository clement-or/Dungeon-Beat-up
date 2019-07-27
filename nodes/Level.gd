extends Node2D

signal end_reached
signal player_hit

func _ready():
	pass

func _on_End_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("end_reached")
	if body.get_name() == "Skeleton":
		body.die()

func get_connection_point():
	return $ConnectionPoint.position + global_position

func _on_Goblin_hit_player():
	emit_signal("player_hit")
