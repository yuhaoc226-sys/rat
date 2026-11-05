extends CharacterBody2D

var speed = 300.0
var jump_velocity = -400.0
<<<<<<< HEAD
var second_jump = true
=======
var items = []
signal pickup(item)
>>>>>>> 236f33e4b63ee4f170261f0b96b639a60888fe91


func _ready() -> void:
	pass
	Global.playerRef = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	speed = 300.0
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		if (second_jump == true):
			velocity.y = jump_velocity
			second_jump = false
	
	if is_on_floor():
		second_jump = true
		
	if Input.is_action_pressed("sprint"):
		speed = 500.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
