extends Node2D

func _ready():
	$Camera2D/Control/CreditsPanel.visible = false


func start_game():
	get_tree().change_scene("res://nodes/Game.tscn")


func credits_close():
	$Camera2D/Control/CreditsPanel.visible = false
func credits_open():
	$Camera2D/Control/CreditsPanel.visible = true
