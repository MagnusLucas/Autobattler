class_name SceneSpawner
extends Node

@export var scene: PackedScene


func spawn_scene(parent: Node = owner) -> Node:
	if !scene:
		return null
	var instance = scene.instantiate()
	parent.add_child(instance)
	return instance
