extends KinematicBody2D

const UP = Vector2(0, -1)

export var v_speed = 300

var is_moving_up = true
var is_dead = false
var motion = Vector2(0, 0)

func _ready():
	is_moving_up = bool(randi()%2+0)

func _physics_process(delta):
	
	if !is_dead:
		if !is_moving_up:
			motion.y = v_speed

		else:
			motion.y = -v_speed

	
	move_and_slide(motion,UP)

func die():
	is_dead = true
	$Sprite.stop()
	motion = Vector2(1000, -1000)
	move_and_slide(motion,UP)
	set_collision_layer(2)
	set_collision_mask(2)
	$DieTimer.start()
	
func delete():
	queue_free()
	
func is_enemy():
	return true


func _on_ChangeDirectionTimer_timeout():
	is_moving_up = !is_moving_up
