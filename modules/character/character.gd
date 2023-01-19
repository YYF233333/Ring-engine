class_name Character
extends Node2D

## Character Root Node
##
## A character is represented by a scene, with [Character] node as its root.
## When add to the SceneTree, this node provide an interface to all functionality needed,
## and manually alter inner nodes should be disallowed.

var standing
