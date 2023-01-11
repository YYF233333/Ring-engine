class_name Layers
extends Node2D

## Collection of Canvas Layers
##
## Auto spawn Layers and provide interface to access and iter through them

## 最大画布层数
const MAX_LAYER_COUNT := 1024

## 初始化所有画布层（性能影响不大）
func _ready() -> void:
    for i in range(MAX_LAYER_COUNT):
        var layer = Layer.new()
        layer.name = String.num_int64(i-MAX_LAYER_COUNT)
        layer.z_index = i-MAX_LAYER_COUNT
        add_child(layer)

## Used to iter through all layers
func get_layers() -> Array[Layer]:
    return get_children()

## Get layer at specific z_index
func get_layer(z: int) -> Layer:
    assert(z >= 0 and z < MAX_LAYER_COUNT)
    return get_child(z) as Layer

## Apply a method to all layers, your return values will be collect and passed back as an Array[br]
## lambda signature: fn(Layer) -> Any
func apply(f: Callable) -> Array:
    assert(get_child_count() == MAX_LAYER_COUNT)
    var ret = get_children().map(f)
    assert(get_child_count() == MAX_LAYER_COUNT)
    return ret

## Reinitialize all layers
func clear() -> void:
    apply(func(x: Layer): x.clear())
