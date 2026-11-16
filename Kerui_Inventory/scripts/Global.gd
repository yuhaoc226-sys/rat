var playerRef: Node2D = null

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
	var file_ref = FileAccess.open("res://Joel_Player/prototype/Storage/playerInventory.json", FileAccess.WRITE)
	file_ref.store_string(converted_json)
	file_ref.close()
