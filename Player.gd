extends CharacterBody2D

const SPEED = 50.0 # originally 300.0
const ACCELERATION = 600

# Chris Vars
@onready var tile_map = $"../TileMap"
var initial_position = global_position
var end_position = global_position
var can_input = true
var movement_path = []

var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32, 16)
	astar_grid.update()
	global_position = Vector2(0,0)
	

func _physics_process(delta):
	#move(delta)
	move_mouse_astar(delta)
	#move_mouse(delta)
	move_and_slide()

func move(delta):
	velocity = Vector2.ZERO
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (dir.x != 0) and (dir.y != 0):
		velocity = (dir*Vector2(32,16))*SPEED*delta
		#$AnimationTree.set("parameters/Idle/blend_position", dir)
	
#func move_mouse():
	#if Input.is_action_just_pressed("leftClick"):
		#global_position = Vector2($"../TileMap".selected_tile)

# Chris Code
func move_mouse(delta: float):
	var current_position = global_position
	# Get the desired end position.
	if Input.is_action_just_pressed("leftClick") && can_input:
		end_position = Vector2(tile_map.selected_tile)
		can_input = false
	
	var normalized_vector = (end_position - current_position).normalized()
	
	# Tiles are incremented (16,8)
	if initial_position != end_position:
		if floor(current_position.x) != end_position.x:
			velocity.x = move_toward(velocity.x, SPEED * normalized_vector.x, ACCELERATION * delta)
		else:
			velocity.x = 0
		if floor(current_position.y) != end_position.y:
			velocity.y = move_toward(velocity.y, SPEED * normalized_vector.y, ACCELERATION * delta / 2)
		else: 
			velocity.y = 0
	
	if velocity.y == 0 && velocity.x == 0:
		can_input = true

func move_mouse_astar(delta: float):
	set_movement_path()
	if movement_path.is_empty(): return
	var target_position = tile_map.map_to_local(movement_path.front())
	global_position = global_position.move_toward(target_position, 1)

	if global_position == target_position:
		movement_path.pop_front()


func set_movement_path():
	if Input.is_action_just_pressed("leftClick") && can_input:
		movement_path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(get_global_mouse_position())
		).slice(1)
