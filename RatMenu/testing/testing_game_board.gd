extends Node2D

@onready var pausingUI = preload("res://Pause Game/uiPause.tscn")
@onready var settingUI = preload("res://Settings/Settings.tscn")
@onready var keyBindUI = preload("res://Settings/Settings.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_uiCall()
	pass
	
func _uiCall() -> void:
	if Input.is_action_just_pressed("openSettings"):
		#$SubViewport.ClearMode = 0
		#$SubViewport.size = Vector2(DisplayServer.screen_get_size())
		$".".add_child(pausingUI.instantiate())
