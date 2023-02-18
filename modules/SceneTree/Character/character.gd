class_name Character
extends Node2D

## Character Root Node
##
## A character is represented by a scene, with [Character] node as its root.
## When add to the SceneTree, this node provide an interface to all functionality needed,
## and manually alter inner nodes should be disallowed.

@onready var standing: Standing = $standing


func say(text: String, append := false) -> void:
    pass

func show_standing(diff_name: String) -> Result:
    return standing.show_diff(diff_name)
    
func apply_transform(transform: Transform) -> void:
    standing.animate_each(transform)

func apply_transition(transition: Transition) -> void:
    pass

