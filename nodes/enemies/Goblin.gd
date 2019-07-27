extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 200

var is_moving_right = true
var is_dead = false
var motion = Vector2(0,0)

func _ready():
	pass

func _physics_process(delta):
	$Sprite.flip_h = !is_moving_right
	
	motion.y += gravity
	if is_on_floor(): motion.y = 0;
	if !is_dead:
		if is_moving_right:
			motion.x = h_speed
		else:
			motion.x = -h_speed
	
	move_and_slide(motion,UP)

func _on_DirectionChangeTimer_timeout():
	if !is_dead:
		is_moving_right = !is_moving_right

func die():
	is_dead = true
	motion = Vector2(2000,-1000)
	move_and_slide(motion,UP)
	set_collision_layer(2)
	set_collision_mask(2)
	$DieTimer.start()
	
func delete():
	queue_free()