class_name ProductType

enum Flag {
    FIRST,
    SECOND,
}

var flag: Flag
var val

func _init(flag: Flag, val = null) -> void:
    self.flag = flag
    self.val = val

func unwrap():
    pass

func unwrap_or(default):
    return self.val if self.flag == Flag.FIRST else default

func map(op: Callable) -> Result:
    if self.flag == Flag.FIRST:
        self.val = op.call(self.val)
    return self

func expect(msg: String):
    if self.flag == Flag.SECOND:
        Assert.panic(msg, ": "+self.val if self.val != null else "")
        return null
    return self.val
