class_name Layers
extends Node2D

## Collection of Canvas Layers
##
## Maintain [Layer]s as child nodes and provide interface to access and iter through them

## 最大画布层数
const MAX_LAYER_COUNT := 1024

## 当前画布层数
@export var layer_count: int = 0: set = set_layer_count

var tween: Tween

## setter of [member layer_count], auto adjust child nodes when change [member layer_count].
func set_layer_count(val: int) -> void:
    print("set layer to ", val)
    assert(val >= 0 and val <= MAX_LAYER_COUNT)
    if val < layer_count:
        for z in range(val, layer_count):
            var layer = get_node(String.num_int64(z))
            remove_child(layer)
            layer.queue_free()
    elif val > layer_count:
        for z in range(layer_count, val):
            var layer = Layer.new()
            layer.name = String.num_int64(z)
            layer.z_index = z
            add_child(layer)
    layer_count = val

## Add new layer on top of layers, fail if total layer num exceed [member MAX_LAYER_COUNT].[br]
## Default to add one layer, you could increase the number, but negatives are [b]NOT[/b] accepted.
func add_layer(num := 1) -> Result:
    assert(num >= 0)
    if layer_count + num > MAX_LAYER_COUNT:
        return Result.Err("Layer num exceed limit")
    layer_count += num
    return Result.Ok()

## Remove layers top down, default to remove one layer.[br]
## Set num to more than [member layer_count] will remove all layers.[br]
## negatives are [b]NOT[/b] accepted.
func remove_layer(num := 1) -> Result:
    assert(num >= 0)
    layer_count = max(layer_count - num, 0)
    return Result.Ok()
        

## Used to iter through all layers
func get_layers() -> Array[Layer]:
    return get_children().map(func(x): return x as Layer)

## Get layer at specific z_index
func get_layer(z: int) -> Layer:
    assert(z >= 0 and z < MAX_LAYER_COUNT)
    if z >= layer_count:
        set_layer_count(z+1)
    # fetch layer by name
    return get_node(String.num_int64(z)) as Layer

## Apply animation to all layers, abort and return on first Error.
## Animation signature: [code]Fn(Tween, Layer) -> Result[/code]
func animate(animation: Callable) -> Result:
    if tween != null:
        tween.kill()
    tween = create_tween().set_parallel()
    for layer in get_layers():
        var res = animation.call(tween, layer)
        if res.is_err():
            return res
    return Result.Ok()

## Reinitialize all layers
func clear() -> void:
    for child in get_children():
        child.clear()

## Debug check
func _process(_delta) -> void:
    if not OS.has_feature("standalone"):
        assert(get_child_count() == layer_count)

