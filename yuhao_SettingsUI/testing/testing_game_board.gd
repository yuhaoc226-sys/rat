extends Node2D

@onready var pausingUI = preload("res://yuhao_SettingsUI/pause/uiPause.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_uiCall()
	pass
	
func _uiCall() -> void:
	if Input.is_action_just_pressed("openSettings"):
		if has_node("uiPause"):
			return

		var pause_instance = pausingUI.instantiate()
		pause_instance.name = "uiPause"
		add_child(pause_instance)
