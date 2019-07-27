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
		motion.x = clamp(motion.x, 500, 100000)
		
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
	motion.x = -100
	$Sprite.animation = "hit"
	$StunTimer.start();
	
#func is_attacking():
#	return $Sprite.animation == "attack"

func _on_Player_hits(body):
	if body.has_method("is_enemy") && body.is_enemy():
		body.die()

func _on_Player_stops_attacking():
	if $Sprite.animation == "attack":
		can_attack = false
		$Sprite.animation = "run"
		$AttackRange/CollisionShape.disabled = true
		
func _on_Player_stopped_dying():
	pass

func _on_AttackCooldown_timeout():
	can_attack = true

func _on_hit_animation_finished():
	if $Sprite.animation == "hit":
		$Sprite.animation = "stun"
		$Sprite.play()
		motion.x = 0


func _on_Player_stops_stun():
	$Sprite.animation = "run"
	is_controllable = true
	$AttackRange/CollisionShape.disabled = true
