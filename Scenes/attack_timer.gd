extends Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".create_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rat_attack_timer() -> void:
	
