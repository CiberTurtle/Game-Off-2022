class_name Bomb extends Node2D

var exploded := false

func _ready() -> void:
	GameEvents.detonate.connect(detonate, Node.CONNECT_ONE_SHOT)
	
	var tween := get_tree().create_tween()
	
	const DURATION := 0.5
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property($Bomb/PointLight2D, 'scale', Vector2.ONE, DURATION).from(Vector2.ZERO)
	tween.parallel().tween_property($Bomb/Radius, 'scale', Vector2.ONE, DURATION).from(Vector2.ZERO)
	tween.parallel().tween_property($Bomb/Radius, 'modulate:a', 1.0, DURATION).from(0.0)

func detonate() -> void:
	if exploded: return
	exploded = true
	
	$Bomb.visible = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play('explode')
	get_tree().create_timer(1.0).timeout.connect(func(): queue_free())
