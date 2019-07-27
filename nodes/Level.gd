extends Node2D

signal end_reached

func _ready():
	pass

func _on_End_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("end_reached")

func get_connection_point():
	return $ConnectionPoint.position + global_position