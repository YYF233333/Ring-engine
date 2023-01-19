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
        var t = []
        for member in group_file[name]:
            match typeof(member):
                TYPE_STRING: t.append(global_asset[member])
                TYPE_ARRAY:
                    assert(member.size() == 3)
                    t.append(_create_asset_with_type(member[0], member[1], member[2]))
                _: Assert.unreachable()
        group[name] = t

func load_asset(name: String) -> Result:
    if not global_asset.has(name):
        return Result.Err("Asset not found")
    return global_asset[name].try_load()

func load_group(name: String) -> Result:
    if not group.has(name):
        return Result.Err("Group not found")
    var ret = {}
    for member in group[name]:
        var res = member.try_load()
        if res.is_err():
            return res
        ret[member.name] = res.unwrap()
    return Result.Ok(ret)

static func _create_asset_with_type(name, path, type):
    match type:
        "JSON": return Asset.new_json(name, path)
        "SCENE": return Asset.new_scene(name, path)
        "IMAGE": return Asset.new_image(name, path)
    Assert.unreachable()
