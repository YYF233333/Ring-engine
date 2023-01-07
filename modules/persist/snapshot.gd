extends Node

## 单例，提供游戏快照保存功能[br]
## 快照逻辑上构成一个队列，回滚时新的快照将被删除[br]
## 通过快照持久化可以提供存档功能（脚本变量需要单独存储）

## 快照索引
var snapshot_name: Dictionary = {}
## 快照队列
var snapshots: Array[Snapshot] = []
## 全局唯一存档计数器，提供默认存档文件名称
var save_counter: int:
    set(val): GlobalValue.set_var_persist("save_counter", val)
    get: return GlobalValue.get_var("save_counter")


class Snapshot:
    var name: String
    # 场景树
    var root: Node
    # 其它需要保存的变量
    var meta: Dictionary
    
    func _init(name: String, root: Node) -> void:
        self.name = name
        self.root = root

func _ready() -> void:
    # 这个方法在游戏最开始执行，应该不会出现save_counter(temp)的情况
    if not GlobalValue.has_var("save_counter"):
        GlobalValue.set_var_persist("save_counter", 0)

## 打印当前的快照队列，可以自定义打印格式[br]
## custom_print需要接受两个参数：[br]
##      name：快照名[br]
##      root：快照场景根节点[br]
func print_snapshots(custom_print: Callable = func(name: String, _root: Node): print(name)) -> void:
    print("=====snapshots=====")
    for snapshot in snapshots:
        custom_print.call(snapshot.name, snapshot.root)
    print("====================")

## 查看当前快照队列中的所有快照名称
func current_snapshots() -> Array[String]:
    var names = []
    for snap in snapshots:
        names.append(snap.name)
    return names

## 创建新快照，可以指定快照名，但不能重复，返回值为新创建的快照的名称
func create_snapshot(root: Node, name: String = "") -> String:
    if name.is_empty():
        name = String.num_int64(save_counter)
        save_counter += 1
    ## 确保快照名不重复
    assert(snapshot_name.has(name) == false)
    var snapshot = Snapshot.new(name, root.duplicate())
    snapshot.meta = GlobalValue.snapshot_vars()
    #print(snapshot.name)
    snapshots.append(snapshot)
    snapshot_name[name] = snapshot
    return name

## 返回指定快照的状态，回滚场景树和标记为SNAPSHOT的全局变量
## 如果无法找到指定快照，返回null，不修改快照队列
func rollback(name: String, prev_root: Node) -> String:
    if snapshot_name[name] == null:
        return "Snapshot not found"
    while not snapshots.is_empty():
        var snap = snapshots.pop_back()
        snapshot_name.erase(snap.name)
        if snap.name == name:
            var root = get_tree().root
            root.remove_child(prev_root)
            root.add_child(snap.root)
            # restore snapshot variables
            for key in snap.meta:
                GlobalValue.set_var_snapshot(key, snap.meta[key])
            return "Ok"
    push_error("Unreachable")
    return ""

## 将快照持久化到磁盘，默认文件名和快照名相同，支持自定义文件名，返回实际使用的文件名[br]
## [color=yellow]Warning:[/color] 已经存在的同名快照将被覆盖
func persist_snapshot(name: String, file_name: String = "") -> String:
    var snapshot: Snapshot = snapshot_name[name]
    # save scenetree
    recursive_set_owner(snapshot.root)
    var scene = PackedScene.new()
    var result = scene.pack(snapshot.root)
    if result == OK:
        if file_name.is_empty():
            file_name = snapshot.name
        var error = ResourceSaver.save(scene, "res://save/"+file_name+".tscn")
        if error != OK:
            push_error("An error occurred while saving the scene to disk.")
    # save snapshot vars
    var meta = JSON.stringify(snapshot.meta, "    ")
    var meta_file = FileAccess.open("res://save/"+file_name+".json", FileAccess.WRITE)
    if meta_file == null:
        push_error("File open error: ", FileAccess.get_open_error())
    meta_file.store_string(meta)
    return file_name

## 从磁盘中加载快照，panic on failure
func load_snapshot(file_name: String, prev_root: Node) -> String:
    var scene = load("res://save/"+file_name+".tscn")
    if scene == null:
        push_error("An error occurred while loading scene ", file_name)
    var meta = JSON.parse_string(FileAccess.get_file_as_string("res://save/"+file_name+".json"))
    assert(meta is not null)
    var root = get_tree().root
    root.remove_child(prev_root)
    root.add_child(scene.instantiate())
    # restore snapshot variables
    for key in meta:
        GlobalValue.set_var_snapshot(key, meta[key])
    return "Ok"
    
## 将root下的所有节点的owner设置为root（[color=yellow]Warning:[/color] 不要手动设置参数owner）
static func recursive_set_owner(root: Node, owner: Node = null) -> String:
    if owner == null:
        owner = root
    for node in root.get_children():
        node.set_owner(owner)
        recursive_set_owner(node, owner)
    return "Ok"
    
