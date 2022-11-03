class_name Bomb extends Node2D

func _enter_tree() -> void:
	GameEvents.detonate.connect(detonate)

func detonate() -> void:
	queue_free()
