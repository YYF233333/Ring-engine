class_name ImageAsset
extends Asset

## Object representing Image Resource

func _init(name: String, path: String) -> void:
    super(name, path, AssetType.IMAGE)

## Custom load implementation
func try_load() -> Result:
    var image = load(path) as ImageTexture
    if image == null:
        return Result.Err("Asset load fail")
    return Result.Ok(image)

## Custom store implementation
func try_store(texture: ImageTexture) -> Result:
    var image := texture.get_image()
    var err := image.save_png(path)
    if err != OK:
        return Result.Err("Image save fail: %s" % err)
    return Result.Ok()


