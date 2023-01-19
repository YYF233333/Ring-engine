class_name Asset

## Object representing a game asset.
##
## This is the format resource being passed through out the engine.
## Subclasses are implemented for different types of resource.
## To implement specific logic for a new resource, simply extend this class,
## override [method _init] and [method try_load].[br]
## Example:
##  [codeblock]
##  class_name CustomAsset
##  extends Asset
##
##  func _init(name, path):
##      self.name = name
##      self.path = path
##      self.category = AssetType.OTHER
##  
##  func try_load() -> Result:
##      return Assert.unimplemented()
##  [/codeblock]

enum AssetType{JSON, SCENE, IMAGE, AUDIO, OTHER}

## Asset name, used by other parts of the engine as well as scripts.
var name: String

## Asset absolute path (start with [code]"res://"[/code]).
var path: String

## Asset Type, used to determin subclass.
var type: AssetType

## [b]Overridable[/b].Directly call constructor from [Asset] will get a type other asset.
func _init(name: String, path: String, type: AssetType) -> void:
    self.name = name
    self.path = path
    self.type = type

## Construct new [JsonAsset].
static func new_json(path: String, name: String = "") -> JsonAsset:
    return JsonAsset.new(name, path)

## Construct new [SceneAsset].
static func new_scene(path: String, name: String = "") -> SceneAsset:
    return SceneAsset.new(name, path)
    
## Construct new [ImageAsset].
static func new_image(path: String, name: String = "") -> ImageAsset:
    return ImageAsset.new(name, path)

## [b]Overridable[/b]. Load asset using method corresponding to the type,
## return Err if load fails.
func try_load() -> Result:
    return Assert.unimplemented("Calling try_load from base Asset class")

## [b]Overridable[/b]. Store data to file using method corresponding to the type,
## return Err if store fails. Tips: you can add type hint for arg in subclass.
func try_store(data) -> Result:
    return Assert.unimplemented("Calling try_store from base Asset class")

# TODO: refactor this
static func str_to_category(s: String) -> AssetType:
    match s:
        "JSON": return AssetType.JSON
        "IMAGE": return AssetType.IMAGE
        "AUDIO": return AssetType.AUDIO
        _ : Assert.unimplemented()
    return AssetType.OTHER


