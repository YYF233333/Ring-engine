class_name Option
extends ProductType

static func Some(val) -> Option:
    return Option.new(Flag.FIRST, val)
    
static func None() -> Option:
    return Option.new(Flag.SECOND, null)

func is_some() -> bool:
    return self.flag == Flag.FIRST

func is_none() -> bool:
    return self.flag == Flag.SECOND

func unwrap():
    if self.flag == Flag.SECOND:
        Assert.panic("Trying to unwrap a None value")
        return null
    return self.val
