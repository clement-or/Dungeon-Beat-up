extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 2000
export var v_speed = 1000

var motion = Vector2()

func _ready():
	$Sprite.animation = "run"

func _physics_process(delta):
	
	# Calculer la gravité
	motion.y += gravity
	motion.x = h_speed
	
	# Check Input
	if is_on_floor():
		#Attack
		if Input.is_action_just_pressed("ui_accept"):
			$Sprite.animation="attack"
			$AttackRange/CollisionShape.disabled = false
			$AttackCooldown.start()
		
		#Jump
		if Input.is_action_pressed("ui_up"):
			motion.y = -v_speed
			$Sprite.animation="jump_start"
	
	# Jump animation
	if !is_on_floor() && motion.y>0:
		$Sprite.animation="jump_end"
	elif is_on_floor() && $Sprite.animation == "jump_end":
		$Sprite.animation = "run"
	
	# Detect death
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collider = get_slide_collision(i).collider
			if collider.has_method("is_enemy") && collider.is_enemy():
				die()
	
	# Calculate physics
	motion = move_and_slide(motion, UP)

func set_text(text):
	$TestLabel.text = text

func die():
	set_text("Ugh I am Dead")
	
func is_attacking():
	return $Sprite.animation == "attack"

func _on_Player_stop_attacking():
	$Sprite.animation = "run"
	$AttackRange/CollisionShape.disabled = true

func _on_Player_hits(body):
		body.die()
