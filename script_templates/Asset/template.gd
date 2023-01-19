# meta-name: Custom Asset
# meta-default: true
# meta-space-indent: 4
class_name _CLASS_Asset
extends Asset

## Object representing _CLASS_ Resource

func _init(name: String, path: String) -> void:
    super(name, path, AssetType.OTHER)

## Custom load implementation
func try_load() -> Result:
    return Assert.unimplemented()

## Custom store implementation
func try_store(data) -> Result:
    return Assert.unimplemented()

