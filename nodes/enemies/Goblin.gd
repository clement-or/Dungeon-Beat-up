extends KinematicBody2D

signal hit_player

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 200

var is_moving_right = true
var motion = Vector2(0,0)
var my_delta = 0

func _ready():
	pass

func _physics_process(delta):
	$Sprite.flip_h = !is_moving_right
	
	# Calculer la gravité
	motion.y += gravity
	if is_on_floor(): motion.y = 0;
	if is_moving_right:
		motion.x = h_speed
	else:
		motion.x = -h_speed
	
	move_and_slide(motion,UP)

func _on_DirectionChangeTimer_timeout():
	is_moving_right = !is_moving_right


func _on_Hitbox_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("hit_player")
