class_name ImageGroup
extends Layers

## Character standing node
##
## Record all standing combinations and display/change them as a whole.

## 差分元数据（各个图层的图片名称），使用差分名索引。
## Dictionary[name, Dictionary[z_index, Texture]]
var standings: Dictionary

func _ready() -> void:
    standings = AssetLoader.get_meta(name)

func display(diff_name: String) -> Result:
    var config: Dictionary = standings[diff_name]
    if config == null:
        return Result.Err("Standing not found")
    for z in config.keys():
        get_layer(z).display_img(config[z])
    return Result.Ok()

