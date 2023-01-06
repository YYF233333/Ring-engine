extends Node

var save_slots: Array[Node] = []
var save_counter: int:
	set(val): GlobalValue.set_var("save_counter", val)
	get: return GlobalValue.get_var("save_counter")


func _ready() -> void:
	if not GlobalValue.has_var("save_counter"):
		GlobalValue.set_var("save_counter", 0)

func print_save_slot() -> void:
	print("=====save slots=====")
	for node in save_slots:
		#print(node.get_child(0).offset.x)
		pass
	print("====================")

func persist_to_mem(node: Node) -> String:
	save_slots.append(node.duplicate())
	return "Ok"
	
func persist_to_disk(node: Node, file_name: String = "") -> String:
	recursive_set_owner(node)
	var scene = PackedScene.new()
	var result = scene.pack(node)
	if result == OK:
		if file_name.is_empty():
			file_name = "%s" % save_counter
			save_counter += 1
		var error = ResourceSaver.save(scene, "res://save/"+file_name+".tscn")
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
	return file_name

func load_from_mem(index: int) -> Node:
	assert(index >= -save_slots.size() and index < save_slots.size())
	if index >= 0:
		save_slots.resize(index+1)
	else:
		save_slots.resize(save_slots.size() - (-index-1))
	return save_slots.pop_back()

func load_from_disk(file_name: String) -> Node:
	print("res://save/"+file_name+".tscn")
	var scene = load("res://save/"+file_name+".tscn").instantiate()
	return scene
	

static func recursive_set_owner(root: Node, owner: Node = null) -> String:
	if owner == null:
		owner = root
	for node in root.get_children():
		node.set_owner(owner)
		recursive_set_owner(node, owner)
	return "Ok"
	
