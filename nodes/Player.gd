extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 600
export var v_speed = 10

var motion = Vector2(0, 1)
var is_controllable = true
var can_attack = true
var score = 0
var combo = 0
var hiscore
var is_hiscore = false
var is_falling = false


func _ready():
	$Sprite.animation = "run"
	$Camera2D/HUD/RestartPopup.fade_in()
	motion.x = 500
	load_game()
	if !hiscore : hiscore = 0
	

func _physics_process(delta):
	# Display HUD
	update_hud()
	if $ComboTimer.is_stopped():
		combo = 0
	motion.y += gravity
	if is_controllable:
		motion.x += 0.3
		motion.x = clamp(motion.x, 500, 100000)
		
		# Check Input
	
		# Attack
		if Input.is_action_just_pressed("ui_accept") && can_attack:
			if is_on_floor():
				$Sprite.animation="attack"
			else:
				$Sprite.animation = "jump_attack"
				$Sprite.play()
			$AttackRange/CollisionShape.disabled = false
			
		#Jump Physics
		if is_on_floor():
			is_falling = false
			if Input.is_action_just_pressed("ui_up"):
				motion.y -= v_speed
		if Input.is_action_just_released("ui_up") && !is_falling:
			is_falling = true
			if motion.y < -1000:
				motion.y = -900
		
		# Jump animation
		if !is_on_floor() && motion.y>0 && $Sprite.animation != "jump_attack":
			$Sprite.animation="jump_end"
		elif is_on_floor() && ($Sprite.animation == "jump_end" || $Sprite.animation == "jump_attack"):
			$Sprite.animation = "run"
	
	# Detect death
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collider = get_slide_collision(i).collider
			if collider && collider.has_method("is_enemy") && collider.is_enemy():
				die()
	
	# Calculate physics
	motion = move_and_slide(motion, UP)
	
func stun():
	is_controllable = false
	motion.x = -100
	$Sprite.animation = "hit"
	$StunTimer.start();
	
#func is_attacking():
#	return $Sprite.animation == "attack"

	######################################################
	# ATTACKING
	######################################################

func _on_Player_hits(body):
	if body.has_method("is_enemy") && body.is_enemy():
		body.die()
		score += 1+combo
		$ComboTimer.start()
		
		if !$ComboTimer.is_stopped():
			combo += 1
			if combo > 1:
				$Hit.text = str(combo)+" Hits !"
			$Camera2D/HUD/Score/anim.play("Combo"+str(randi()%2+0))
			$Hit/anim.play("Combo"+str(randi()%2+0))
		if !combo : $Camera2D/HUD/Score/anim.play("Hit"+str(randi()%2+0))

func _on_Player_stops_attacking():
	if $Sprite.animation == "attack":
		can_attack = false
		$Sprite.animation = "run"
		$AttackRange/CollisionShape.disabled = true
	elif $Sprite.animation == "jump_attack":
		can_attack = false
		if !is_on_floor(): $Sprite.animation = "jump_end"
		$AttackRange/CollisionShape.disabled = true
		
	######################################################
	# DYING
	######################################################
		
func die():
	is_controllable = false
	$Sprite.animation = "die"
	motion.x = 0
	set_collision_layer(2)
	if score > hiscore:
		is_hiscore = true
		hiscore = score
		save_game()
		
func _on_Player_stopped_dying():
	if $Sprite.animation == "die":
		$Camera2D/HUD/RestartPopup/Panel/Score.text = "Score : "+str(score)
		$Camera2D/HUD/RestartPopup/Panel/Hiscore.text = "Hi-score : "+str(hiscore)
		if is_hiscore: $Camera2D/HUD/RestartPopup/Panel/New.visible = true
		$Camera2D/HUD/RestartPopup.visible = true

func _on_hit_animation_finished():
	can_attack = true
	if $Sprite.animation == "hit":
		$Sprite.animation = "stun"
		$Sprite.play()
		motion.x = 0

func _on_Player_stops_stun():
	$Sprite.animation = "run"
	is_controllable = true
	$AttackRange/CollisionShape.disabled = true

func update_hud():
	$Camera2D/HUD/Score.text = str(score)


func _on_ComboTimer_timeout():
	combo = 0
	$Hit.text = ""
	
func save():
	return {
	"hiscore" : score
	}

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	call("save");
	save_game.store_line(to_json(save()))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		save_game()
		return
	
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		if current_line: hiscore = current_line.get("hiscore")
	if !hiscore: hiscore = 0
	save_game.close()