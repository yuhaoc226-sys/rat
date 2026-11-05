extends Control
@onready var pausingUI = preload("res://Pause Game/uiPause.tscn")
@onready var settingUI = preload("res://Settings/Settings.tscn")
@onready var keyBindUI = preload("res://Settings/Settings.tscn")
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_settings_button_down() -> void:
	$".".add_child(settingUI.instantiate())
	#$".".visible = false


func _on_resume_game_button_down() -> void:
	$".".queue_free()
	
