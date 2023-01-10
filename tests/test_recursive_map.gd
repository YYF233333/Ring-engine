func run():
    test1()

var counter := 0:
    get:
        counter += 1
        return counter

func construct_tree() -> Node:
    var root = Node.new()  
    for i in range(3):
        var node = Node.new()
        node.name = String.num_int64(counter)
        root.add_child(node)
        for j in range(3):
            var node2 = Node.new()
            node2.name = String.num_int64(counter)
            node.add_child(node2)
    return root
    

func test1():
    var tree = construct_tree()
    SnapshotServer.recursive_map(tree, func(n, a): print(n.name), null)
    tree.free()
