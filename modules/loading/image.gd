class_name ImageAsset
extends Asset

## Object representing Image Resource

func _init(name: String, path: String) -> void:
    super(name, path, AssetType.IMAGE)

## Custom load implementation
func try_load() -> Result:
    return Assert.unimplemented()

## Custom store implementation
func try_store(data) -> Result:
    return Assert.unimplemented()


