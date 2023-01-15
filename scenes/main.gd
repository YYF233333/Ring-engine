extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $background.add_layer()
    $background.get_layer(0).display_img(load("res://icon.svg"))
    $background.get_layer(0).position = Vector2(300.0, 300.0)
    $background.animate(Transform.fade_out(1.0))
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        $background.animate(Transform.fade_in(1.0))
    elif Input.is_action_just_pressed("ui_cancel"):
        $background.animate(Transform.fade_out(1.0))
    #$background.clear()
    pass
