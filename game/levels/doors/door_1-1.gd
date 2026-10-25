extends Area2D

@export_file("*.tscn") var target_scene: String
@export var target_spawn: StringName

func _on_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		TransitionManager.spawn_name = target_spawn
		get_tree().call_deferred(
			"change_scene_to_file",
			target_scene
		)
