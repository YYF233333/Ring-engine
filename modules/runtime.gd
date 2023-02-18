extends Node

##  Main Interface of Ring Engine.
##
##  This is an API collector for all other modules, provide an unified and simplified
##  GDscript Interface (Since they can move to C# at some point).

## Node contains current running script
var user_script_node: Node

## [code]func _part{next_section}[/code] will be called next time [method step] is called.
var next_section: int:
    set(val): GlobalVar.set_var_snapshot("NextSection", val)
    get: return GlobalVar.get_var("NextSection").unwrap()


## Engine initialization
func _ready() -> void:
    if not DirAccess.dir_exists_absolute("res://save"):
        DirAccess.make_dir_absolute("res://save")
    GlobalVar.set_var("ViewportSize", get_viewport().get_visible_rect().size)
    GlobalVar.set_var("TextSpeed", 20.0)
    register_script($/root/main)

#TODO: Move this func to UI part
func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        Runtime.step()

## change current activated script to provided node.
func register_script(script_node: Node) -> void:
    var script = ScriptParser.process(script_node.get_script())
    var err = script.reload()
    assert(err == OK)
    script_node.set_script(script)
    user_script_node = script_node
    next_section = 0

## step forward, call next part of script.
func step() -> void:
    user_script_node.call("_part%s" % next_section)
    next_section += 1

func get_char():
    var group = AssetLoader.get_global("红叶").unwrap()
    var chara = group.get_member("红叶").unwrap()
    var hongye = chara.try_load().unwrap().instantiate()
    $/root/main.add_child(hongye)
    return hongye
