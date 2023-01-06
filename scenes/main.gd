extends Node2D

var tmp:
	set(val): GlobalValue.set_var("tmp", val, true)
	get: return GlobalValue.get_var("tmp")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		Save.persist_to_mem(self)
		tmp = tmp+1 if tmp else 1
		print("tmp is: ", tmp)
		self.position.x += 10
		$Sprite2D.offset.x += 10
		#print("now pos is ", $Sprite2D.offset.x)
		#Save.print_save_slot()
	elif Input.is_action_pressed("ui_left"):
		tmp -= 1
		var node = Save.load_from_mem(tmp)
		print("tmp is: ", tmp)
		#print("get node with pos ", node.get_child(0).offset.x)
		#Save.print_save_slot()
		get_tree().get_root().add_child(node)
		get_tree().get_root().remove_child(self)
		self.queue_free()
