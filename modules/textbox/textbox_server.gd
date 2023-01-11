extends Node

var main_textbox: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    main_textbox = preload("res://modules/textbox/textbox_main.tscn").instantiate()
    #get_tree().root.add_child(main_textbox)


