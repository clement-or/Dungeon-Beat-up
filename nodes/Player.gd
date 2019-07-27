extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var v_speed = 1000

var motion = Vector2()
var is_controllable = true
var can_attack = true

func _ready():
	$Sprite.animation = "run"
	motion.x = 500

func _physics_process(delta):
	
	# Calculer la gravité
	motion.y += gravity
	set_text(str(motion.x))
	
	if is_controllable:
		motion.x += 0.3
		
		# Check Input
		if is_on_floor():
			#Attack
			if Input.is_action_just_pressed("ui_accept") && can_attack:
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
	is_controllable = false
	$Sprite.animation = "die"
	motion.x = 0
	set_collision_layer(2)
	
func stun():
	is_controllable = false
	
#func is_attacking():
#	return $Sprite.animation == "attack"

func _on_Player_hits(body):
		body.die()

func _on_Player_stops_attacking():
	
	# Player stops attacking
	if $Sprite.animation == "attack":
		can_attack = false
		$Sprite.animation = "run"
		$AttackRange/CollisionShape.disabled = true
		
	# Player has finished dying

func _on_AttackCooldown_timeout():
	can_attack = true
