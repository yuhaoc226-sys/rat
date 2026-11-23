extends Node

var playerRef = null

func _exit_tree():
	pushToJSONDB(playerRef.items)


func pushToJSONDB(array):
	var json_push = {
		"items":[]
	}
	for item in array:
		json_push["items"].append({
			"name" : item.item_name,
			"id" : item.id,
			"description" : item.description
		})
	var converted_json = JSON.stringify(json_push)
	var file_ref = FileAccess.open("res://Kerui_Inventory/data/playerInventory.json", FileAccess.WRITE)
	file_ref.store_string(converted_json)
	file_ref.close()
func pullFromJSONDB():
	var arrayOfItemsFromDB = []
	#var file = FileAccess.open("res://Kerui_Inventory/data/playerInventory.json", FileAccess.READ)
	#print(dictFromFile)
	#for item in dictFromFile["items"]:
#		arrayOfItemsFromDB.append(gameItems.new(item["name"], item["id"]))
	return arrayOfItemsFromDB
