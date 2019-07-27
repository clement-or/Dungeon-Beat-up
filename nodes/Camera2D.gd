extends Camera2D

var speed = 10

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position.x+=speed
	if Input.is_action_pressed("ui_left"):
		position.x-=speed
	