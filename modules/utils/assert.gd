class_name Assert

## Mimic corresponding macros in Rust.
##
## Leave the return types unspecified, so we can coerce return value to any type.
## Enable usage like:
##  [codeblock]
##  func f() -> Result:
##      return Assert.unimplemented()
##  [/codeblock]

static func unimplemented(msg: String = "", arg1 = "", arg2 = "", arg3 = ""):
    var message = "not implemented"
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    assert(false, message)

static func unreachable(msg: String = "", arg1 = "", arg2 = "", arg3 = ""):
    var message = "entered unreachable code"
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    assert(false, message)

static func panic(msg: String = "", arg1 = "", arg2 = "", arg3 = ""):
    var message = "program panicked at "
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    else:
        message += "explicit panic"
    assert(false, message)

static func chain(args: Array) -> String:
    return args.reduce(func(a, b): return a+("%s" % b), "")
