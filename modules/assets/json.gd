class_name JsonAsset
extends Asset

## Object representing Json Resource

func _init(name: String, path: String) -> void:
    super(name, path, AssetType.JSON)

func try_load() -> Result:
    var asset = FileAccess.get_file_as_string(path)
    if asset.length() == 0:
        return Result.Err("Asset load fail")
        
    return parse_json(asset)

func try_store(data: Dictionary) -> Result:
    var json := JSON.stringify(data, "    ")
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        return Result.Err("Cannot open file "+path+": %s" % FileAccess.get_open_error())
    file.store_string(json)
    return Result.Ok()

static func parse_json(data: String) -> Result:
    if data == null:
        return Result.Err("Asset load fail")
    var json = JSON.new()
    var parse_result = json.parse(data)
    if parse_result != OK:
        return Result.Err("JSON Parse Error: %s in %s at line %s"
            % [json.get_error_message(), data, json.get_error_line()])
    var dict = json.get_data()
    return Result.Ok(dict)
