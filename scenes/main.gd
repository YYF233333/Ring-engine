extends Node2D

var ptr := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
    
static func script() -> void:
    #var hongye = Runtime.get_char()
    #hongye.show_standing("1")
    #hongye.apply_transform(Show.at_middle())
    TextboxServer.main_textbox.show_text("114")
    #var hongye = Runtime.get_char()
    #hongye.show_standing("1")
    #hongye.apply_transform(Show.at_right())
    TextboxServer.main_textbox.show_text("514")
