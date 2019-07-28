extends Control

var is_quit = false

func _ready():
	$Panel.visible = false

func fade_out():
	$ColorRect.visible = true
	$ColorRect/anim.play("fade_out")

func _on_anim_animation_finished(anim_name):
	if anim_name == "fade_out" && !is_quit:
		get_tree().reload_current_scene()
	elif anim_name == "fade_in":
		$ColorRect.visible = false
		visible = false
		$Panel.visible = true
	elif anim_name == "fade_out" && is_quit:
		get_tree().change_scene("res://nodes/Menu.tscn")
	
func fade_in():
	$ColorRect.visible = true
	$ColorRect.color = Color(1,1,1,1)
	$ColorRect/anim.play("fade_in")

func quit():
	is_quit = true
	fade_out()
