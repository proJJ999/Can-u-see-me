extends CharacterBody2D

signal enemy_seen

@export var turn_speed := PI/2
@export var watch_distance := 350

var rays : Array[RayCast2D]
var seen_player : CharacterBody2D

func _ready() -> void:
	rays = gather_rays()
	update_watch_distance(rays, watch_distance)


func gather_rays() -> Array[RayCast2D]:
	var rays: Array[RayCast2D] = []
	for child in get_children():
		if child.is_in_group("enemy_rays"):
			rays.append(child)
	return rays


func update_watch_distance(rays: Array[RayCast2D], value: int) -> void:
	for ray in rays:
		ray.target_position.y = -value


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








