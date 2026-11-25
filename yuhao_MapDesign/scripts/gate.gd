extends AnimatableBody2D
@export var move_distance_vertical: Vector2= Vector2(0,-1000)
@export var move_distance_horizontal: Vector2 = Vector2(-200, 0)
@export var move_distance: Vector2 = move_distance_vertical
@export var move_duration: float = 0.5

var _is_open : bool = false
var tween: Tween
var _start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_position = position

func open()-> void: 
	if _is_open: return
	_is_open = true
	_animate_door(_start_position + move_distance)
	
func alter_direction() -> void:
	if not _is_open:
		if (move_distance == move_distance_vertical):
			move_distance = move_distance_horizontal
		else:
			move_distance = move_distance_vertical


func _animate_door(target_position: Vector2) -> void:
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", target_position, move_duration)
	
func close():
	if not _is_open: return
	_is_open = false
	_animate_door(_start_position )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_pressed("ui_left"):
		#open()
	#if Input.is_action_pressed("ui_right"):
		#close()
	#if Input.is_action_pressed("ui_accept"):
		#alter_direction()
