extends Node

## 单例，提供游戏快照保存功能[br]
## 快照逻辑上构成一个队列，回滚时新的快照将被删除[br]
## 通过快照持久化可以提供存档功能（脚本变量需要单独存储）[br]
## 对于不想保存的节点，可以在[method _exit_tree]中释放

## 快照索引
var snapshot_name: Dictionary = {}
## 快照队列
var snapshots: Array[Snapshot] = []
## 全局唯一存档计数器，提供默认存档文件名称
var save_counter: int:
    set(val): GlobalVar.set_var_persist("save_counter", val)
    get: return GlobalVar.get_var("save_counter")


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
    if not GlobalVar.has_var("save_counter"):
        GlobalVar.set_var_persist("save_counter", 0)

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
func create_snapshot(root: Node, name: String = "") -> Result:
    if name.is_empty():
        name = String.num_int64(save_counter)
        save_counter += 1
    ## 确保快照名不重复
    if snapshot_name.has(name):
        return Result.Err("duplicate snapshot "+name)
    var snapshot = Snapshot.new(name, root.duplicate())
    snapshot.meta = GlobalVar.snapshot_vars()
    #print(snapshot.name)
    snapshots.append(snapshot)
    snapshot_name[name] = snapshot
    return Result.Ok(name)

## 返回指定快照的状态，回滚场景树和标记为SNAPSHOT的全局变量
## 如果无法找到指定快照，返回null，不修改快照队列
func rollback(name: String, prev_root: Node) -> Result:
    if not snapshot_name.has(name):
        return Result.Err("Snapshot not found")
    while not snapshots.is_empty():
        var snap = snapshots.pop_back()
        snapshot_name.erase(snap.name)
        if snap.name == name:
            var root = get_tree().root
            root.remove_child(prev_root)
            root.add_child(snap.root)
            # restore snapshot variables
            for key in snap.meta:
                GlobalVar.set_var_snapshot(key, snap.meta[key])
            return Result.Ok()
    Assert.unreachable()
    return Result.Err(null)

## 将快照持久化到磁盘，默认文件名和快照名相同，支持自定义文件名，返回实际使用的文件名[br]
## [color=yellow]Warning:[/color] 已经存在的同名快照将被覆盖
func persist_snapshot(name: String, file_name: String = "") -> Result:
    var snapshot: Snapshot = snapshot_name[name]
    # save scenetree
    recursive_set_owner(snapshot.root)
    var scene = PackedScene.new()
    var result = scene.pack(snapshot.root)
    if result != OK:
        return Result.Err("pack scene failed: %s" % result)
    if file_name.is_empty():
        file_name = snapshot.name
    var error = ResourceSaver.save(scene, "res://save/"+file_name+".tscn")
    if error != OK:
        return Result.Err("save scene failed: %s" % error)
    # save snapshot vars
    var meta = JSON.stringify(snapshot.meta, "    ")
    var meta_file = FileAccess.open("res://save/"+file_name+".json", FileAccess.WRITE)
    if meta_file == null:
        return Result.Err("File open error: %s" % FileAccess.get_open_error())
    meta_file.store_string(meta)
    return Result.Ok(file_name)

## 从磁盘中加载快照，加载成功后会自动替换当前场景
func load_snapshot(file_name: String, prev_root: Node) -> Result:
    var scene = load("res://save/"+file_name+".tscn")
    if scene == null:
        return Result.Err("An error occurred while loading scene "+ file_name)
    var meta = AssetLoader.load_json_from_file("res://save/"+file_name+".json")
    if meta.is_err():
        return Result.Err("loading metadata of "+file_name+" failed: "+meta.unwrap_err())
    var parent = prev_root.get_parent()
    assert(parent != null)
    parent.remove_child(prev_root)
    parent.add_child(scene.instantiate())
    # restore snapshot variables
    for key in meta:
        GlobalVar.set_var_snapshot(key, meta[key])
    return Result.Ok()
    
## 将root下的所有节点的owner设置为root（[color=yellow]Warning:[/color] 不要手动设置参数owner）
static func recursive_set_owner(root: Node, owner: Node = null) -> void:
    recursive_map(
        root,
        func(node: Node, owner: Node):
            if node != owner:
                node.set_owner(owner),
        root if owner == null else owner
    )

static func recursive_map(root: Node, method: Callable, global_arg: Variant) -> void:
    for node in root.get_children():
        ## 中序遍历防止运行时修改
        recursive_map(node, method, global_arg)
        method.call(node, global_arg)
        
