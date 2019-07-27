extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 2000
export var v_speed = 1000

var motion = Vector2()
var my_delta = 0

func _ready():
	$Sprite.animation = "run"

func _physics_process(delta):
	my_delta = 50 * delta
	
	# Calculer la gravité
	motion.y += my_delta * gravity
	motion.x = my_delta * h_speed
		
	if is_on_floor() && Input.is_action_pressed("ui_up"):
		motion.y = -v_speed
		$Sprite.animation="jump_start"
	if !is_on_floor() && motion.y>0:
		$Sprite.animation="jump_end"
	elif is_on_floor() && $Sprite.animation != "jump_start":
		$Sprite.animation = "run"
	
	motion = move_and_slide(motion, UP)
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Goblin" in get_slide_collision(i).collider.name:
				die()

func set_text(text):
	$TestLabel.text = text

func die():
	set_text("Ugh I am Dead")
	pass