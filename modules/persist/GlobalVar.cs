/* 单例，全局变量存储器，保存在场景切换后或者游戏重新加载时需要保持不变的数据[br]
* 典型用途：[br]
*  1.脚本变量影射全局变量：
*  [codeblock]
*  var a: int:
*      set(val): GlobalValue.set_var("a", val)
*      get: GlobalValue.get_var("a")
*  [/codeblock]
*/

using Godot;
using System;
using Godot.Collections;




public partial class GlobalVar : Node
{
    // 全局变量类型
    public enum VarType
    {
        SNAPSHOT, // 跟随存档一起保存，加载存档时覆盖
        TEMP, // 保存在内存中，切换场景时保持，关闭游戏丢失
        PERSIST // 关闭游戏时将保存到磁盘
    }
    class GlobalVariable : RefCounted
    {
        public VarType type;
        public Variant value;

        public GlobalVariable(VarType type, Variant value)
        {
            this.type = type;
            this.value = value;
        }
    }

    Godot.Collections.Dictionary<String, GlobalVariable> global_var;

    // 初始化或者修改全局变量值，默认创建TEMP类型的变量
    public void set_var(String name, Variant value)
    {
        global_var[name] = new GlobalVariable(VarType.TEMP, value);
    }
    // [method set_var]PERSIST变体
    public void set_var_persist(String name, Variant value)
    {
        global_var[name] = new GlobalVariable(VarType.PERSIST, value);
    }
    // [method set_var]SNAPSHOT变体
    public void set_var_snapshot(String name, Variant value)
    {
        global_var[name] = new GlobalVariable(VarType.SNAPSHOT, value);
    }

    // Return global var corresponding to the name.
    public Variant get_var(String name)
    {
        return global_var[name].value;
    }

    // Test if the var exists.
    public bool has_var(String name)
    {
        return global_var.ContainsKey(name);
    }

    // 获取全局变量类型(PERSIST/TEMP/SNAPSHOT)（不是变量自己的类型）
    public VarType var_type(String name)
    {
        return global_var[name].type;
    }

    // 获取所有需要被快照保存的变量
    public Dictionary snapshot_vars()
    {
        var snap_vars = new Dictionary();
        foreach (var entry in global_var)
        {
            var key = entry.Key;
            var variable = entry.Value;
            if (variable.type == VarType.SNAPSHOT)
            {
                if (variable.value.VariantType == Variant.Type.Array)
                {
                    snap_vars[key] = ((Godot.Collections.Array)variable.value).Duplicate(true);
                }
                else if (variable.value.VariantType == Variant.Type.Dictionary)
                {
                    snap_vars[key] = ((Godot.Collections.Dictionary)variable.value).Duplicate(true);
                }
                else
                {
                    snap_vars[key] = variable.value;
                }
            }
        }
        return snap_vars;
    }

    public override void _EnterTree()
    {
        var global_persist =
    }
    var global_persist = Asset.new_json("res://save/global_variables.json"
        ).try_load().unwrap_or({})
        for key in global_persist:
            global_var[key] = GlobalVariable.new(VarType.PERSIST, global_persist[key])



    public override void _ExitTree()
        var global_persist = { }
    for key in global_var:
            if global_var[key].type == VarType.PERSIST:
                global_persist[key] = global_var[key].value
        var err = Asset.new_json("res://save/global_variables.json").try_store(global_persist)
        if err.is_err():
            push_error(err.unwrap_err())
}
