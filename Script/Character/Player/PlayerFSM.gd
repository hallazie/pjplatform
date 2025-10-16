class_name PlayerFSM extends Node2D

enum BaseState
{
    Idle,
    Run,
    Sprint,
    SprintJump,
    Jump,
    RollDodge,
    WallSlide,
}

enum BaseTransaction
{
    JumpStart,
    JumpEnd,
    SprintStart,
    SprintEnd,    
}

var main: Player = null
var input: PlayerInput = null


func _init_signals():
    pass


func update_state():
    pass
