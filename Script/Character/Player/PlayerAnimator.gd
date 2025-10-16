class_name PlayerAnimator extends Node2D

@onready var upperbody: AnimatedSprite2D = $Upperbody


var main: Player = null
var state: PlayerFSM = null
var movement: PlayerMovement = null
var sensor: PlayerSensor = null

var playing_transaction: bool = false


func _init_signals():
    main.START_SPRINT_RUN.connect(on_start_sprint_run)
    main.STOP_SPRINT_RUN.connect(on_stop_sprint_run)
    upperbody.animation_finished.connect(on_upperbody_finished)
    
    
func update_animator(delta: float):
    if playing_transaction:
        return
    if sensor.is_on_wall_type != PlayerSensor.SensorWallType.None and not sensor.is_on_ground:
        upperbody.play("WallSlide")
    else:
        if state.move_state == PlayerFSM.MoveState.RollDodge:
            upperbody.play("RollDodge")
        elif movement.vertical_speed > 0:
            upperbody.play("JumpUp")
        elif movement.vertical_speed < 0:
            upperbody.play("JumpDown")
        else:
            if main.velocity != Vector2.ZERO:
                if movement.move_speed > movement.max_run_speed:
                    upperbody.play("Run")
                else:
                    upperbody.play("Walk")
            else:
                upperbody.play("Idle")
                
    if main.facing == Enums.Direction.Right:
        scale = Vector2(-1, 1)
    else:
        scale = Vector2(1, 1)


func play_transaction(transaction: PlayerFSM.Transaction):
    if transaction == PlayerFSM.Transaction.SprintStart:
        upperbody.play("RunStart")
        playing_transaction = true
    elif transaction == PlayerFSM.Transaction.SprintEnd:
        upperbody.play("RunEnd")
        playing_transaction = true
    
    
func on_upperbody_finished():
    if upperbody.animation == "RollDodge":
        main.STOP_ROLL.emit()
    elif upperbody.animation == "RunStart":
        playing_transaction = false
        state.transaction = PlayerFSM.Transaction.None
    elif upperbody.animation == "RunEnd":
        playing_transaction = false
        state.transaction = PlayerFSM.Transaction.None
    

func on_start_sprint_run():
    play_transaction(PlayerFSM.Transaction.SprintStart)
    
    
func on_stop_sprint_run():
    play_transaction(PlayerFSM.Transaction.SprintEnd)
    
    
