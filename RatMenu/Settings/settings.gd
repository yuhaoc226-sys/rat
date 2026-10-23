extends Control
@onready var pausingUI = preload("res://Pause Game/uiPause.tscn")
@onready var settingUI = preload("res://Settings/Settings.tscn")
@onready var keyBindUI = preload("res://Settings/KeyBinds.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_save_pressed() -> void:
	$".".queue_free()


func _on_key_bind_pressed() -> void:
	$".".add_child(keyBindUI.instantiate())
	
	
