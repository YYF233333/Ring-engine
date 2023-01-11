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

## Return the contained Ok value or panic on Err.
func unwrap():
    if self.flag == Flag.SECOND:
        Assert.panic("Trying to unwrap an Err value containing ", self.val)
        return null
    return self.val

## Return the contained Err value or panic on Ok
func unwrap_err():
    if self.flag == Flag.FIRST:
        Assert.panic("Trying to unwrap_err an Ok value containing ", self.val)
        return null
    return self.val

## Converts the Err value by applying a function to it, leaving an Ok value untouched.
func map_err(op: Callable) -> Result:
    if self.flag == Flag.SECOND:
        self.val = op.call(self.val)
    return self
