extends Node2D

@export var starting_point := 0

@export var move_speed := 32.0

@export var turn_rate := 0.5

@onready var curve: Curve2D = get_parent().curve

var seg_progress := 0.0
var seg_length := 1.0
var seg_point := 0
var seg_start := Vector2.ZERO
var seg_end := Vector2.ZERO
var seg_rotation := 0.0

func _ready() -> void:
	seg_point = starting_point
	update_segment()

func _physics_process(delta: float) -> void:
	if rotation == seg_rotation:
		seg_progress += move_speed * delta
	else:
		rotation = rotate_toward(rotation, seg_rotation, TAU * turn_rate * delta)
	
	if seg_progress >= seg_length:
		next_segment()
		seg_progress = 0.0
	
	var ratio := seg_progress / seg_length
	position = lerp(seg_start, seg_end, ratio)

func rotate_toward(from: float, to: float, delta: float) -> float:
	var angle = delta_angle(from, to)
	if -delta < angle and angle < delta:
		return to
	to = from + angle
	return move_toward(from, to, delta)

func delta_angle(a: float, b: float) -> float:
	return repeat(b - a, TAU)

func repeat(value: float, length: float) -> float:
	return clamp(value - floor(value / length) * length, 0.0, length)

func next_segment() -> void:
	if seg_point == curve.point_count - 1:
		seg_point = 0
	else:
		seg_point += 1
	
	update_segment()

func update_segment() -> void:
	if seg_point >= curve.point_count - 2:
		seg_start = curve.get_point_position(seg_point)
		seg_end = curve.get_point_position(0)
	else:
		seg_start = curve.get_point_position(seg_point)
		seg_end = curve.get_point_position(seg_point + 1)
	
	seg_length = seg_start.distance_to(seg_end)
	seg_rotation = seg_start.angle_to_point(seg_end)
