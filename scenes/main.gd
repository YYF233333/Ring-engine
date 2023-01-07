extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_pressed("ui_right"):
        SnapshotServer.create_snapshot(self)
        self.position.x += 10
        $Sprite2D.offset.x += 10
        #print("now pos is ", $Sprite2D.offset.x)
        #Save.print_save_slot()
    elif Input.is_action_pressed("ui_left"):
        var res = SnapshotServer.rollback(SnapshotServer.current_snapshots()[-1], self)
        if res == "Ok":
            self.queue_free()
