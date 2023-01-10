class_name Result
extends ProductType

static func Ok(val = null) -> Result:
    return Result.new(Flag.FIRST, val)

static func Err(val) -> Result:
    return Result.new(Flag.SECOND, val)

func is_ok() -> bool:
    return self.flag == Flag.FIRST

func is_err() -> bool:
    return self.flag == Flag.SECOND

func unwrap():
    if self.flag == Flag.SECOND:
        Assert.panic("Trying to unwrap an Err value containing ", self.val)
        return null
    return self.val

func unwrap_err():
    if self.flag == Flag.FIRST:
        Assert.panic("Trying to unwrap_err an Ok value containing ", self.val)
        return null
    return self.val

func map_err(op: Callable) -> Result:
    if self.flag == Flag.SECOND:
        self.val = op.call(self.val)
    return self
