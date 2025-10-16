class_name PlayerFSM extends Node2D

enum MoveState
{
    Idle,
    Run,
    Sprint,
    SprintJump,
    Jump,
    RollDodge,
    WallSlide,
}

enum ActState
{
    None,
    Attack,
    Interact,
    Act,
}

enum Transaction
{
    None,
    JumpStart,
    JumpEnd,
    SprintStart,
    SprintEnd,    
}

var main: Player = null
var input: PlayerInput = null
var movement: PlayerMovement = null


var move_state: MoveState = MoveState.Idle
var act_state: ActState = ActState.None
var transaction: Transaction = Transaction.None

func _init_signals():
    main.START_JUMP.connect(on_start_jump)
    main.START_WALL_JUMP.connect(on_start_wall_jump)
    main.START_LAND_GROUND.connect(on_start_land_ground)
    main.START_LAND_WALL.connect(on_start_land_wall)
    main.START_ROLL.connect(on_start_roll)
    main.STOP_ROLL.connect(on_stop_roll)
    main.START_RUN.connect(on_start_run)
    main.STOP_RUN.connect(on_stop_run)


func update_state(delta: float):
    update_move_state()
    update_act_state()
    
    
func update_move_state():
    """
    根据状态进行调整，即State主要由事件驱动，但会根据状态进行调整
    """
    pass    
    
    
func update_act_state():
    pass
    
func on_start_jump():
    move_state = MoveState.Jump
    
func on_start_wall_jump():
    move_state = MoveState.Jump
         
func on_start_land_ground():
    move_state = MoveState.Idle
    
func on_start_land_wall():
    move_state = MoveState.WallSlide

func on_start_roll():
    move_state = MoveState.RollDodge
    
func on_stop_roll():
    if input.ctl_move_direction != 0:
        if input.ctl_is_sprint_long_press:
            move_state = MoveState.Sprint
        else:
            move_state = MoveState.Run  
    else:
        move_state = MoveState.Idle
        
    
func on_start_run():
    move_state = MoveState.Run
    
    
func on_stop_run():
    move_state = MoveState.Idle
    
