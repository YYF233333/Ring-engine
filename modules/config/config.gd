extends Node

## 全局常量和全局初始化、清理代码

func _ready() -> void:
    if not DirAccess.dir_exists_absolute("res://save"):
        DirAccess.make_dir_absolute("res://save")
    GlobalVar.set_var("ViewportSize", get_viewport().get_visible_rect().size)
