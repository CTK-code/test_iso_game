extends CharacterBody2D

const SPEED = 50.0 # originally 300.0
const ACCELERATION = 600

# Chris Vars
@onready var tile_map = $"../TileMap"
var initial_position = global_position
var end_position = global_position
var can_input = true

func _physics_process(delta):
	#move(delta)
	move_mouse(delta)
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

func move_tile(horizontal: Vector2, vertical: Vector2):
	
	pass
		
