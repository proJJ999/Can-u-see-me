extends CharacterBody2D

signal enemy_seen

@export var turn_speed := PI/2
@export var watch_distance := 350

var rays : Array[RayCast2D]
var seen_player : CharacterBody2D

@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	rays = gather_rays()
	update_watch_distance(rays, light, watch_distance)


func gather_rays() -> Array[RayCast2D]:
	var rays: Array[RayCast2D] = []
	for child in get_children():
		if child.is_in_group("enemy_rays"):
			rays.append(child)
	return rays


func update_watch_distance(
		rays: Array[RayCast2D],
		light: PointLight2D,
		value: int
		) -> void:
	for ray in rays:
		ray.target_position.y = -value
	# Dependant on the size of the light texture
	var light_default_range: int = 128
	var light_scale := float(value)/float(light_default_range)
	light.scale = Vector2(light_scale, light_scale)


func _physics_process(delta: float) -> void:
	seen_player = get_seen_player(rays)
	
	if seen_player == null:
		rotation += turn_speed * delta
		return
	
	var player_pos := seen_player.position
	var direction_to_player := position.direction_to(player_pos)
	var rotation_to_player := direction_to_player.angle() + PI/2
	rotation = rotation_to_player
	
	

func get_seen_player(rays: Array[RayCast2D]) -> CharacterBody2D:
	for ray in rays:
		if not ray.is_colliding():
			continue
		var collider = ray.get_collider()
		if collider.is_in_group("player"):
			return collider
	return null








