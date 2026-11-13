class_name gameItems

var name: String
var id: int
var spritePath: String
var description: String

func _init(i_name: String, i_id):
	name = i_name
	id = i_id
	#todo, add a database index to get 
	#description and spritepath based on ID by looking for it in the JSON file
	
