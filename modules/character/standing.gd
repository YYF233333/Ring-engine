class_name Standing
extends Layers

## Character standing node
##
## Record all standing combinations and display/change them as a whole.

## 差分元数据（各个图层的图片名称），使用差分名索引。
## Dictionary[name, Dictionary[z_index, Texture]]
var meta: Dictionary

func _ready() -> void:
    var chara_name = get_parent().name
    var group: AssetGroup = AssetLoader.get_group(chara_name).expect("Character setup fail")
    meta = group.get_member("meta").unwrap()
    

func display(diff_name: String) -> Result:
    var config: Dictionary = meta[diff_name]
    if config == null:
        return Result.Err("Standing not found")
    return Assert.unimplemented()

