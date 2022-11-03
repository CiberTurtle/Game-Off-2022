class_name Player extends CharacterBody2D

@export var speed := 64.0

@export var bomb_scene: PackedScene

var _move := Vector2.ZERO
var _plant_bomb := false
var _detonate := false

func _enter_tree() -> void:
	Gloabls.player = self

func _process(delta: float) -> void:
	_move.x = Input.get_axis('move_left', 'move_right')
	_move.y = Input.get_axis('move_up', 'move_down')
	
	if Input.is_action_just_pressed('plant_bomb'):
		_plant_bomb = true
	
	if Input.is_action_just_pressed('detonate'):
		_detonate = true

func _physics_process(delta: float) -> void:
	velocity = _move.normalized() * speed
	move_and_slide()
	
	if _plant_bomb:
		_plant_bomb = false
		plant_bomb()
	
	if _detonate:
		_detonate = false
		detonate()

func plant_bomb():
	var bomb := bomb_scene.instantiate() as Bomb
	get_parent().add_child(bomb)
	bomb.position = position

func detonate():
	GameEvents.detonate.emit()
