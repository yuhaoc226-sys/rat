class_name gameItems

var name: String
var id: String
var spritePath: String
var description: String

func _init(i_name: String, i_id: String):
	name = i_name
	id = i_id
	spritePath = ""
	description = ""
	#todo, add a database index to get 
	#description and spritepath based on ID by looking for it in the JSON file
	
func printOutItemPropterties():
	print(name + " " + str(id))
	
func getName():
	return name
func getId():
	return id
func getDescription():
	return description
