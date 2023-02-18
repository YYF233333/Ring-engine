class_name ScriptParser

##  User script preprocessor
##
##  Now it is just some hard code logic, but planned to evolve to a full preprocessor
##  with lexer, parser, and even optimization pass. Inspired by Rust proc-macro.
##  This is a glue class, real implementation is in [code]Parser.cs[/code]

static func process(script: GDScript) -> GDScript:
    if not script.has_source_code():
        Assert.panic("Source code not available")
    var source := script.get_source_code()
    # find func script()
    # TODO: a proper way to find function end
    source = source.get_slice("func script", 1)
    source = source.get_slice(":", 1)
    print(source)
    # some ugly hack
    source += "\n\n"
    # got function body
    # split at character.say()
    var parts = []
    while source.find(".show_text") != -1:
        var split = source.find(")", source.find(".show_text"))
        parts.append(source.substr(0, split+2))
        source = source.substr(split+1)
    
    var res = ""
    for i in range(0, parts.size()):
        res += "func _part%s() -> void:%s" % [i, parts[i]]
        
    res = script.source_code.substr(0, script.source_code.find("func script")) + res
    var script_processed = GDScript.new()
    script_processed.source_code = res
    script_processed.reload()
    return script_processed

