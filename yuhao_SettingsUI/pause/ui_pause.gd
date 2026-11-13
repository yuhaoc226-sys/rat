extends Control
@onready var pausingUI = preload("res://yuhao_SettingsUI/pause/uiPause.tscn")
@onready var settingUI = preload("res://yuhao_SettingsUI/settings/Settings.tscn")
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_settings_button_down() -> void:
	var settings_instance = settingUI.instantiate()
	settings_instance.name = "Settings"
	add_child(settings_instance)


func _on_resume_game_button_down() -> void:
	$".".queue_free()
	
