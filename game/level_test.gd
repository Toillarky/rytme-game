extends Node2D

func _ready() -> void:
	var spawn_name = TransitionManager.spawn_name
	if spawn_name == &"":
		return
	
	var player = get_tree().get_first_node_in_group("player")
	var spawn = get_node_or_null(
		NodePath("SpawnPoint/" + str(spawn_name))
	)

	if player != null and spawn != null:
		player.global_position = spawn.global_position
	TransitionManager.spawn_name = &""
