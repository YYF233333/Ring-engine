extends Node2D

## 最大画布层数
const MAX_LAYER_COUNT := 1024

func _ready() -> void:
    for i in range(MAX_LAYER_COUNT):
        var layer = Sprite2D.new()
        layer.name = String.num_int64(i-MAX_LAYER_COUNT)
        layer.z_index = i-MAX_LAYER_COUNT
        add_child(layer)

func display(name: String, layer: int = 0) -> void:
    assert(layer >= 0 and layer < MAX_LAYER_COUNT)
    var node = get_child(layer) as Sprite2D
    node.texture = load(name)

func clear_layer(layer: int) -> void:
    var node = get_child(layer) as Sprite2D
    node.texture = null
    node.position = Vector2.ZERO

func clear() -> void:
    for i in range(MAX_LAYER_COUNT):
        clear_layer(i)
