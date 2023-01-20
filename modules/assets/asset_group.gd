class_name AssetGroup

## Group name
var name: String

# Dict[name, Asset]
var members: Dictionary = {}

func _init(name: String) -> void:
    self.name = name

func add_member(asset) -> void:
    members[asset.name] = asset

## Return [code]true[/code] if member exists, otherwise [code]false[/code]
func remove_member(name: String) -> bool:
    return members.erase(name)

func get_member(name: String) -> Option:
    if members.has(name):
        return Option.Some(members[name])
    return Option.None()
