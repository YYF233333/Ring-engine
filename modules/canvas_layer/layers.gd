class_name Layers
extends Node2D

## Collection of Canvas Layers
##
## Maintain [Layer]s as child nodes and provide interface to access, 
## modify and iter through them. [Layer]s are orgnized as a stack of canvas, 
## with the index representing their relative height.
## All layer share the same z_index of their parent([Layers])
## when compared to other nodes.

## 最大画布层数
const MAX_LAYER_COUNT := 1024

## 当前画布层数
@export var layer_count: int = 0: set = set_layer_count

## Tween shared by child layers
var tween: Tween

## setter of [member layer_count], auto adjust child nodes when change [member layer_count].
func set_layer_count(val: int) -> void:
    print("set layer to ", val)
    assert(val >= 0 and val <= MAX_LAYER_COUNT)
    if val < layer_count:
        for i in range(val, layer_count):
            var layer = get_node(String.num_int64(i))
            remove_child(layer)
            layer.queue_free()
    elif val > layer_count:
        for i in range(layer_count, val):
            var layer = Layer.new()
            layer.name = String.num_int64(i)
            add_child(layer)
    layer_count = val

# Constructor

## Create a new [Layers] with [member layer_count] set to given value
static func with_layer_count(layer_count: int) -> Layers:
    var ret = Layers.new()
    ret.layer_count = layer_count
    return ret

## Add new layer on top of layers, 
## fail if total layer num exceed [member MAX_LAYER_COUNT].[br]
## Default to add one layer, you could increase the number, 
## but negatives are [b]NOT[/b] accepted.
func add_layer(num := 1) -> Result:
    assert(num >= 0)
    if layer_count + num > MAX_LAYER_COUNT:
        return Result.Err("Layer num exceed limit")
    layer_count += num
    return Result.Ok(layer_count)

## Remove layers top down, return total layer number after remove.
## default to remove one layer. Set num to more than [member layer_count] 
## will remove all layers.[br]
## negatives are [b]NOT[/b] accepted.
func remove_layer(num := 1) -> int:
    assert(num >= 0)
    layer_count = max(layer_count - num, 0)
    return layer_count

## Apply animation to all layers.
## If you want to animate single layer, see [method Layer.animate].
func animate_each(animation: Transform) -> void:
    if tween != null:
        tween.kill()
    tween = create_tween().set_parallel()
    for layer in get_layers():
        animation.action(tween, layer)

## Reinitialize all layers
func clear() -> void:
    for child in get_children():
        child.clear()

# Low Level API

## Used to iter through all layers
func get_layers() -> Array[Layer]:
    return get_children().map(func(x): return x as Layer)

## Get layer at specific index.
func get_layer(index: int) -> Layer:
    assert(index >= 0 and index < MAX_LAYER_COUNT)
    if index >= layer_count:
        set_layer_count(index+1)
    return get_child(index) as Layer

## Debug check
func _process(_delta) -> void:
    if not OS.has_feature("standalone"):
        assert(get_child_count() == layer_count)

