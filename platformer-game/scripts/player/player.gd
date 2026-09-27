extends CharacterBody2D

#region Variveis exportadas para ajuste de gameplay
@export var SPEED := 130.0
@export var JUMP_VELOCITY := -230.0
@export var acceleration := 900.0
@export var friction := 700.0
#endregion

#region Nodes importados
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
#endregion

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	movement(delta)
	move_and_slide()
	updateAnimation()

	
func apply_gravity(delta: float):
		if not is_on_floor():
			velocity += get_gravity() * delta
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
		
func movement(delta: float):
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, acceleration * delta)
		if direction != 0.0:
			animated.flip_h = direction < 0.0
		else:
			animated.flip_h = direction
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)		
func jump():
	velocity.y = JUMP_VELOCITY


func updateAnimation():
	if not is_on_floor():
		if velocity.y < 0.0:
			animated.play("Jump")
		else:
			animated.play("Fall")
	elif velocity.x != 0.0:
		animated.play("Run")
	else:
		animated.play("Idle")
