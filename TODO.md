- [x] 重构animation，使用工厂模式而不是lambda
- [x] 重构loading system
    提供一个素材载入抽象（Godot目前还没有一个很好的解决方案，刚看到有人抱怨到处都是字符串）
    应当能够：
    - 编译时完全确定所有素材所在路径
    - 运行时向系统的其它部分提供索引来获取这些对象（这个索引要稳定）
    - 开发时素材路径发生变化可以一键重新生成路径和索引的对应关系
    - (Optional)自动维护素材缓存，按需加载，实现一个类似Streaming的模块
    TODO:
    - [x] 设计索引格式
      - [x] 添加嵌套group
      - [ ] (Optional)检查namespace中名称是否重复
    - [x] 设计素材在模块内部的索引格式
    - [x] 编写脚本一键重新构建索引
      - [x] 构建全局namespace中的asset索引
      - [x] 构建group索引
    - [x] 编写模块本体
      - [x] 索引转换
      - [x] 素材打包/分组
      - [x] group load
    - [ ] (Optional)添加缓存逻辑
    - [ ] (Optional)编辑器可视化操作
    - [x] 重构Asset，包含存储逻辑，做成统一I/O界面
    - [x] benchmark资源加载(一张图40ms，已经超过了60fps要求的16.67ms)
      ![](load_benchmark.jpg)
    - [ ] 异步加载
    - [ ] 提供一些简单的容器类型
- [ ] audio system
- [ ] 实现文本框
- [ ] 实现角色类
  - [ ] meta.json
- [ ] runtime API collect
- [ ] 把即兴剧移植过来
- [ ] rely more on C# and less on Godot
  - [ ] 使用LiteDB作为持久化存储方案

## 脚本执行
Problem
- 脚本解释器（GDScript Interpreter）不是Ring Engine的一部分，无法定制其行为，脚本对于运行时完全是个blackbox
- GDScript不仅是图灵完备的，而且拥有和运行时一样的访问引擎的能力，运行时不是引擎的一个wrapper
- Godot保存场景不保存脚本状态
- 不能要求用户做太多适配（由于架构原因，用户已经要写很多boilerplate code了）
- 如何做到异步可重入

### Design 1
数组存放lambda函数，lambda stateless，使用元素间隔代表中断点，全局变量保存执行进度。
cons：丑，lambda boilerplate code

### Design 2 —— Accepted
Source generator 编译时修改脚本，拆分为多个函数，记录函数间调用顺序，生成状态保存代码。
cons：如何复用现有的language support

脚本编写采用连续方式，启动时process source code，将脚本函数打断，每段构成一个lambda/static func，运行时依次调用

language support唯一失效的点是无法提示哪里会等待键盘输入，可以通过简单约定解决。

snapshot保存：脚本被打断后stateless，只需要保存一个全局的调用状态就行了

user script需要是static func方便Runtime调用，所有的调用都要过Ring engine

- [ ] 确定转换规范
    - [ ] 局部变量保存问题
    - [ ] 语义顺序保持

e.g. 
```GDScript
func script() -> void:
    var a = 1;
    use(a)
    Character.say("abab")
    use(a)
```
should split into
```GDScript
func _part0() -> void:
    var a = 1;
    use(a)
    Character.say("abab")
func _part1() -> void:
    var a = 1;
    use(a)
```
or move all definition to outer space
- [ ] 编写parser
- [ ] 执行状态保存
