extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Attack/TextEdit.placeholder_text = "x"
	$Jump/TextEdit.placeholder_text = "z"
	$"MoveLeft/TextEdit".placeholder_text = "left arrow"
	$MoveRight/TextEdit.placeholder_text = "right arrow"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	$".".queue_free()
	pass # Replace with function body.
