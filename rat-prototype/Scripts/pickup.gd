extends Node2D

var item_name: String
var id: int 
var description: String

# this is a constructor for a pickup item, pass in the result of the load() function of an image 

func create_instance(name: String, id: int, des: String, texture: Resource):
	var scene1 = load("res://pickup.tscn")
	var instance = scene1.instantiate()
	instance.id = id
	instance.item_name = name 
	instance.description = des
	return instance
