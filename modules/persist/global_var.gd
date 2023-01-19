extends Node

## 单例，全局变量存储器，保存在场景切换后或者游戏重新加载时需要保持不变的数据[br]
## 典型用途：[br]
##  1.脚本变量影射全局变量：
##  [codeblock]
##  var a: int:
##      set(val): GlobalValue.set_var("a", val)
##      get: GlobalValue.get_var("a")
##  [/codeblock]

## 全局变量类型
enum VarType {
    SNAPSHOT, ## 跟随存档一起保存，加载存档时覆盖
    TEMP, ## 保存在内存中，切换场景时保持，关闭游戏丢失
    PERSIST ## 关闭游戏时将保存到磁盘
}

var global_var: Dictionary = {}

class GlobalVariable:
    var type: VarType
    var value: Variant
    
    func _init(type: VarType, value: Variant) -> void:
        self.type = type
        self.value = value

## 初始化或者修改全局变量值，默认创建TEMP类型的变量
func set_var(name: String, value: Variant) -> void:
    global_var[name] = GlobalVariable.new(VarType.TEMP, value)

## [method set_var]PERSIST变体
func set_var_persist(name: String, value: Variant) -> void:
    global_var[name] = GlobalVariable.new(VarType.PERSIST, value)

## [method set_var]SNAPSHOT变体
func set_var_snapshot(name: String, value: Variant) -> void:
    global_var[name] = GlobalVariable.new(VarType.SNAPSHOT, value)

## Return global var corresponding to the name.
func get_var(name: String) -> Result:
    if not global_var.has(name):
        return Result.Err(null)
    else:
        return Result.Ok(global_var.get(name).value)

## Test if the var exists.
func has_var(name: String) -> bool:
    return global_var.has(name)

## 获取全局变量类型(PERSIST/TEMP/SNAPSHOT)（不是变量自己的类型）
func var_type(name: String) -> Result:
    if not global_var.has(name):
        return Result.Err(null)
    else:
        return Result.Ok(global_var[name].type)

## 获取所有需要被快照保存的变量
func snapshot_vars() -> Dictionary:
    var snap_vars = {}
    for key in global_var:
        if global_var[key].type == VarType.SNAPSHOT:
            var value = global_var[key].value
            if typeof(value) == TYPE_ARRAY or typeof(value) == TYPE_DICTIONARY:
                snap_vars[key] = value.duplicate(true)
            else:
                snap_vars[key] = value
    return snap_vars

func _enter_tree() -> void:
    var global_persist = Asset.new_json("res://save/global_variables.json"
        ).try_load().unwrap_or({})
    for key in global_persist:
        global_var[key] = GlobalVariable.new(VarType.PERSIST, global_persist[key])
        

func _exit_tree() -> void:
    var global_persist = {}
    for key in global_var:
        if global_var[key].type == VarType.PERSIST:
            global_persist[key] = global_var[key].value
    var err = Asset.new_json("res://save/global_variables.json").try_store(global_persist)
    if err.is_err():
        print(err.unwrap_err())
