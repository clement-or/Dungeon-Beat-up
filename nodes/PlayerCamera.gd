extends Camera2D

func _ready():
	pass

func _physics_process(delta):
	global_position.x = get_node("/root/Game").player.global_position.x