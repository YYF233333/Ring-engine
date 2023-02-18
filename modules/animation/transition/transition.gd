class_name Transition

## Type 2 animation, used to animate transform from one standing to another.
##
##  This is the base class. To create a Transition:[br]
##  1. Create a new class extend this base class.[br]
##  2. Override [method action] to implement specific logic.[br]
##  3. Create convenient presets.

## Transition last time in seconds.
var duration: float
## see [member Tween.EaseType]
var ease_type: Tween.EaseType
## see [member Tween.TransitionType]
var trans_type: Tween.TransitionType

func _init(
    duration: float,
    ease_type: Tween.EaseType,
    transition_type: Tween.TransitionType
) -> void:
    self.duration = duration
    self.ease_type = ease_type
    self.trans_type = transition_type


## Transition function, apply animation to [layers] provided.
## Should be overriden in sub class to implement specific logic.
func action(_layers: Layers) -> void:
    Assert.unimplemented("Calling transition action from base class")
