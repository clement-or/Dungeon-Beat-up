extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var h_speed = 600
export var is_moving_right = true

var is_dead = false
var motion = Vector2(0,0)
var can_change_dir = false

func _ready():
	pass

func _physics_process(delta):
	$Sprite.flip_h = is_moving_right
	
	motion.y += gravity
	if is_on_floor(): motion.y = 0;
	if !is_dead:
		if is_moving_right:
			motion.x = h_speed
		else:
			motion.x = -h_speed
	if is_on_wall() && can_change_dir:
		is_moving_right = !is_moving_right
		can_change_dir = false
		$ChangeDirectionTimer.start()
	
	move_and_slide(motion,UP)

func die():
	is_dead = true
	$Sprite.stop()
	motion = Vector2(0,-2000)
	move_and_slide(motion,UP)
	set_collision_layer(2)
	set_collision_mask(2)
	$DieTimer.start()
	
func delete():
	queue_free()
	
func is_enemy():
	return true

func _on_ChangeDirectionTimer_timeout():
	can_change_dir = true
