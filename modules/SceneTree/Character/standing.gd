class_name Standing
extends Layers

## Character standing node
##
## Record all standing combinations and display/change them as a whole.

## 差分元数据（各个图层的图片名称），使用差分名索引。
## Dictionary[name, Dictionary[z_index, Texture]]
var diffs: Dictionary
var chara_name = get_parent().name

func _ready() -> void:
    var group: AssetGroup = AssetLoader.get_global(chara_name).expect("Character setup fail")
    var diff_config = group.get_member("meta").unwrap().try_load().unwrap()
    diffs = setup_diff(diff_config)

func setup_diff(config: Dictionary) -> Dictionary:
    var diffs = {}
    for diff_name in config:
        var layers = {}
        for layer in config[diff_name]:
            layers[layer] = AssetLoader.get_global(
                chara_name).unwrap().get_member(config[diff_name][layer]).unwrap()
        diffs[diff_name] = layers
    return diffs
    

func show_diff(diff_name: String) -> Result:
    var diff = diffs[diff_name]
    for layer in diff:
        get_layer(int(layer)).display(diff[layer])
    return Result.Ok()

