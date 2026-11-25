extends Node2D

var attack_scene: PackedScene = load("res://Scenes/rat_attack.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_rat_attack(pos) -> void:
	var attack = attack_scene.instantiate()
	$".".add_child(attack)
	attack.position = pos
	print("attack")
