class_name Assert

static func unimplemented(msg: String = "", arg1 = "", arg2 = "", arg3 = "") -> void:
    var message = "not implemented"
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    push_error(message)
    assert(false)

static func unreachable(msg: String = "", arg1 = "", arg2 = "", arg3 = "") -> void:
    var message = "entered unreachable code"
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    push_error(message)
    assert(false)

static func panic(msg: String = "", arg1 = "", arg2 = "", arg3 = "") -> void:
    var message = "program panicked at "
    if msg != "":
        message += chain([": ", msg, arg1, arg2, arg3])
    else:
        message += "explicit panic"
    push_error(message)
    assert(false)

static func chain(args: Array) -> String:
    return args.reduce(func(a, b): return a+("%s" % b), "")
