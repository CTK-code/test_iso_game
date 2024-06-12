extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	move(delta)
	move_mouse()
	move_and_slide()
	
func move(delta):
	velocity = Vector2.ZERO
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (dir.x != 0) and (dir.y != 0):
		velocity = (dir*Vector2(32,16))*SPEED*delta
		#$AnimationTree.set("parameters/Idle/blend_position", dir)
	
func move_mouse():
	if Input.is_action_just_pressed("leftClick"):
		global_position = Vector2($"../TileMap".selected_tile)
