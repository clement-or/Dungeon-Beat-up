extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 2000
export var v_speed = 1000

var motion = Vector2()
var my_delta = 0

func _ready():
	pass

func _physics_process(delta):
	my_delta = 50 * delta
	
	# Calculer la gravité
	motion.y += my_delta * gravity
	motion.x = my_delta * h_speed
		
	if is_on_floor() && Input.is_action_pressed("ui_up"):
		motion.y = -v_speed
	
	motion = move_and_slide(motion, UP)

func set_text(text):
	$TestLabel.text = text

func die():
	pass