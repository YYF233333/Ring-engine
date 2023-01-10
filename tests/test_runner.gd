extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var test_files = Array(DirAccess.get_files_at("res://tests")).filter(
        func(name): return name.ends_with(".gd") and name != "test_runner.gd"
    )
    
    for file in test_files:
        var case = load("res://tests/"+file).new()
        case.call("run")
    
    print("finish all tests")
