extends Node

var main_textbox: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    main_textbox = preload("res://modules/SceneTree/Textbox/textbox_main.tscn").instantiate()
    get_tree().root.add_child.call_deferred(main_textbox)
