extends Node2D

var direction = Vector2(0,0)
var leaving = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (rotation_degrees == 0):
		direction = Vector2(0,-1000)
	if (rotation_degrees == 90):
		direction = Vector2(-1000,0)
	if (rotation_degrees == 180):
		direction = Vector2(1000,0)
	if (rotation_degrees == 270):
		direction = Vector2(1000,0)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

		
func _on_player_leaving_the_scene(body: Node2D) -> void:
	leaving = true
	if body is CharacterBody2D:
		body.velocity= Vector2(0,-1000)


func _on_player_entering_the_scene(body: Node2D) -> void:
	if body is CharacterBody2D and !leaving:
		body.velocity= Vector2(0,-1000) *-1
