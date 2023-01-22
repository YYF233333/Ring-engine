class_name Assets
extends Node


## 素材/素材组全局命名空间
var global_namespace: Dictionary = {}

## assets folder structure
var asset_tree: Dictionary = {}

func _ready() -> void:
    var assets: Dictionary = Asset.new_json("res://config/assets.json"
        ).try_load().expect("Assets meta broken")
    # build asset_tree
    for name in assets:
        asset_tree[name] = _parse_entry(name, assets[name])
        global_namespace[name] = asset_tree[name]

## Return Asset/Group corresponding to the name in global namespace.
func get_global(name: String) -> Option:
    if not global_namespace.has(name):
        return Option.None()
    return Option.Some(global_namespace[name])

## Add an Asset/Group to global namespace, 
## return error if name conflict with exist Asset/Group.
func add_to_global(obj) -> Result:
    if global_namespace.has(obj.name):
        return Result.Err("Name conflict")
    global_namespace[obj.name] = obj
    return Result.Ok()

## Remove an Asset/Group corresponding to the name from global namespace,
## return [code]true[/code] if it does exists, otherwise [code]false[/code].
func remove_from_global(name: String) -> bool:
    return global_namespace.erase(name)

func _parse_entry(key: String, val: Dictionary):
    print("parse entry ", key)
    if val["type"] == "GROUP":
        return _parse_group(key, val)
    else:
        return _parse_asset(key, val)

func _parse_group(key: String, val: Dictionary) -> AssetGroup:
    assert(val["type"] == "GROUP")
    var ret = AssetGroup.new(key)
    var members: Dictionary = val["members"]
    for name in members:
        ret.add_member(_parse_entry(name, members[name]))
    if val.get("global", false):
        global_namespace[key] = ret
    return ret
    
func _parse_asset(key: String, val: Dictionary):
    var path = val["path"]
    var asset = _create_asset_with_type(key, val["path"], val["type"])
    if val.get("global", false):
        global_namespace[key] = asset
    return asset
        

static func _create_asset_with_type(name, path, type):
    match type:
        "JSON": return JsonAsset.new(name, path)
        "SCENE": return SceneAsset.new(name, path)
        "IMAGE": return ImageAsset.new(name, path)
    return Assert.unreachable()
