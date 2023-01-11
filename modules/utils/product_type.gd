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

## Return the contained Ok/Some value or panic.[br]
## Should not be call in base class
func unwrap():
    Assert.unimplemented(
        "Calling unwrap method of base type, should be overidden by subclass.")

## Return the contained Ok/Some value without checking that the value is not Err/None.[br]
## Push a warning if you do unwrap an Err/None value.
func unwrap_unchecked():
    if self.flag == Flag.SECOND:
        push_warning("Unwrapping an Err/None value without check: ", self.val)
    return self.val

## Return the contained Ok/Some value or a provided default.
func unwrap_or(default):
    return self.val if self.flag == Flag.FIRST else default

## Return the contained Ok/Some value or computes it from a closure.[br]
## lambda signatrue: Fn(err: Variant) -> Variant
func unwrap_or_else(f: Callable):
    return self.val if self.flag == Flag.FIRST else f.call(self.val)

## Converts the Ok/Some value by applying a function to it, leaving an Err/None value untouched.
func map(f: Callable) -> Result:
    if self.flag == Flag.FIRST:
        self.val = f.call(self.val)
    return self

## Unwrap a Result/Option with custom panic message
func expect(msg: String):
    if self.flag == Flag.SECOND:
        Assert.panic(msg, ": "+self.val if self.val != null else "")
        return null
    return self.val
