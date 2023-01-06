extends Node

var global_var: Dictionary = {}
var global_temp: Dictionary = {}

func set_var(name: String, value: Variant, temp: bool = false) -> String:
	global_var[name] = value
	if temp:
		global_temp[name] = true
	elif global_temp.has(name):
		global_temp.erase(name)
	return "Ok"

func get_var(name: String) -> Variant:
	return global_var.get(name)

func has_var(name: String) -> bool:
	return global_var.has(name)

func is_temp(name: String) -> bool:
	return global_temp.has(name)

func _enter_tree() -> void:
	var json = JSON.new()
	var data = FileAccess.get_file_as_string("res://save/global_variables.json")
	# Check if there is any error while parsing the JSON string, skip in case of failure
	if data:
		var parse_result = json.parse(data)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())
			return
		global_var = json.get_data()

func _exit_tree() -> void:
	
	for key in global_temp.keys():
		global_var.erase(key)
	var data = JSON.stringify(global_var, "    ")
	if not DirAccess.dir_exists_absolute("res://save"):
		DirAccess.make_dir_absolute("res://save")
	var global_file = FileAccess.open("res://save/global_variables.json", FileAccess.WRITE)
	if global_file == null:
		print("File open error: ", FileAccess.get_open_error())
		return
	global_file.store_string(data)
	return
