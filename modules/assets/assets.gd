class_name Assets
extends Node


## 全局命名空间中的素材索引
var global_asset: Dictionary = {}

## 素材组索引
var group: Dictionary = {}

func _ready() -> void:
    var global_file: Dictionary = Asset.new_json("res://config/assets.json"
        ).try_load().expect("Asset meta broken")
    for name in global_file.keys():
        var path = global_file[name][0]
        var type = global_file[name][1]
        global_asset[name] = _create_asset_with_type(name, path, type)
    
    var group_file: Dictionary = Asset.new_json("res://config/groups.json"
        ).try_load().expect("Asset group meta broken")
    for name in group_file.keys():
        var g = AssetGroup.new(name)
        for member in group_file[name]:
            match typeof(member):
                TYPE_STRING: g.add_member(global_asset[member])
                TYPE_ARRAY:
                    assert(member.size() == 3)
                    g.add_member(_create_asset_with_type(member[0], member[1], member[2]))
                _: Assert.unreachable()
        group[name] = g

func get_asset(name: String) -> Option:
    if not global_asset.has(name):
        return Option.None()
    return Option.Some(global_asset[name])

func get_group(name: String) -> Option:
    if not group.has(name):
        return Option.None()
    return Option.Some(group[name])

static func _create_asset_with_type(name, path, type):
    match type:
        "JSON": return JsonAsset.new(name, path)
        "SCENE": return SceneAsset.new(name, path)
        "IMAGE": return ImageAsset.new(name, path)
    Assert.unreachable()
