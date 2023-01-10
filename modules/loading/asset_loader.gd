extends Node

@export var assets: Dictionary

func _ready() -> void:
    assets = load_json_from_file("res://config//assets.json").unwrap_or({})

func load_asset(name: String) -> Result:
    if not assets.has(name):
        return Result.Err("Asset not found")
    var asset = load(assets[name])
    if asset == null:
        return Result.Err("Load failed")
    return Result.Ok(asset)

func load_img(name: String) -> Result:
    return load_asset(name).map_err(
            func(e): return "failed to load img "+name+": "+e
        )

func load_scene(name: String) -> Result:
    return load_asset(name).map_err(
        func(e): return "failed to load scene "+name+": "+e
    )

static func load_absolute(path: String) -> Result:
    var asset = load(path)
    if asset == null:
        return Result.Err("Load failed")
    return Result.Ok(asset)

static func load_json_from_file(path: String) -> Result:
    var data = FileAccess.get_file_as_string(path)
    if data == null:
        return Result.Err("loading falied")
    var json = JSON.new()
    var parse_result = json.parse(data)
    if not parse_result == OK:
        return Result.Err("JSON Parse Error: %s in %s at line %s"
            % [json.get_error_message(), data, json.get_error_line()])
    var dict = json.get_data()
    return Result.Ok(dict)
