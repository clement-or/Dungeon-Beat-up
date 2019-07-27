extends Node2D

var segments = [
	preload("res://nodes/Level.tscn")
]
var current_segments = [
	null,
	null
]

func _ready():
	current_segments[1] = segments[0].instance()
	current_segments[1].position = Vector2(0,0)
	current_segments[1].connect("end_reached", self, "_on_Level_end_reached")
	add_child(current_segments[1])

var rnd_segment
func _on_Level_end_reached():
		# Supprimer le segment précédent
	if current_segments[0]:
		current_segments[0].queue_free()

	current_segments[0] = current_segments[1] # passer le segment actuel en précédent segment
	rnd_segment = randi()%segments.size()+0  # choisir un segment aléatoire entre 0 et nb de segments
	current_segments[1] = segments[rnd_segment].instance()  # instancier le nouveau segment
	current_segments[1].connect("end_reached", self, "_on_Level_end_reached") # connecter le signal
	# <source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	
	# Placer le nouveau segment à la fin du segment précédent
	var point = current_segments[0].get_connection_point()
	current_segments[1].position = point
	call_deferred("add_child", current_segments[1]) # ajouter à la scène
	