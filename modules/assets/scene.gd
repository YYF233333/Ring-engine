class_name SceneAsset
extends Asset

## Object representing Scene Resource

func _init(name: String, path: String) -> void:
    super(name, path, AssetType.SCENE)

## Custom load implementation
func try_load() -> Result:
    var scene = load(path) as PackedScene
    if scene == null:
        return Result.Err("Asset load fail")
    return Result.Ok(scene)

## Custom store implementation
func try_store(root: Node) -> Result:
    var scene = PackedScene.new()
    var err = scene.pack(root)
    if err != OK:
        return Result.Err("Scene pack fail: %s" % err)
    err = ResourceSaver.save(scene, path)
    if err != OK:
        return Result.Err("Scene save fail: %s" % err)
    return Result.Ok()


