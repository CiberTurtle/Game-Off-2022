extends Node2D

@export var move_speed := 32.0
@export var nearby_distance := 24.0
@export var turn_rate := 1.0

@onready var nearby_distance_sqr := nearby_distance * nearby_distance
@export var nearby_speed_dec := 16.0

@onready var curve: Curve2D = get_parent().curve

var seg_progress := 0.0
var seg_length := 1.0
var seg_point := 0
var seg_start := Vector2.ZERO
var seg_end := Vector2.ZERO
var seg_rotation := 0.0
var turn_time := 0.0

func _ready() -> void:
	seg_point = 0
	next_segment()

func _physics_process(delta: float) -> void:
	var is_nearby := position.distance_squared_to(Gloabls.player.position) < nearby_distance_sqr
	var spd := (move_speed - nearby_speed_dec) if is_nearby else move_speed
	if rotation == seg_rotation:
		seg_progress += spd * delta
	else:
		turn_time += delta
		rotation = rotate_toward(rotation, seg_rotation, 4 * PI * turn_rate * delta)
	
	if seg_progress >= seg_length:
		next_segment()
		turn_time = 0.0
		seg_progress = 0.0
	
	var ratio := seg_progress / seg_length
	position = lerp(seg_start, seg_end, ratio)

func rotate_toward(from: float, to: float, delta: float) -> float:
	var angle = delta_angle(from, to)
	if -delta < angle and angle < delta:
		return to
	to = from - angle
	return move_toward(from, to, delta)

func delta_angle(a: float, b: float) -> float:
	return repeat(b - a + PI, TAU) - PI

func repeat(value: float, length: float) -> float:
	return clamp( value - floor( value / length ) * length, 0.0, length)

func next_segment():
	if seg_point == curve.point_count:
		seg_point = 0
	else:
		seg_point += 1
	
	if seg_point == curve.point_count - 1:
		seg_start = curve.get_point_position(seg_point)
		seg_end = curve.get_point_position(0)
	else:
		seg_start = curve.get_point_position(seg_point)
		seg_end = curve.get_point_position(seg_point + 1)
	
	seg_length = seg_start.distance_to(seg_end)
	seg_rotation = seg_start.angle_to_point(seg_end)
