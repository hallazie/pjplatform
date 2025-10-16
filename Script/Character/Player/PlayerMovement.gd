class_name PlayerMovement extends Node2D


var main: Player = null
var state: PlayerFSM = null
var input: PlayerInput = null
var sensor: PlayerSensor = null


var max_run_speed: float = 160
var max_sprint_speed: float = 260
var max_roll_speed: float = 400
var ground_jump_init_speed: float = 500
var wall_jump_init_speed: float = 400
var wall_zig_init_speed: float = 600
var wall_slide_speed: float = -80
var run_acceleration: float = 100
var run_deceleration: float = 800
var sprint_acceleration: float = 200
var sprint_deceleration: float = 1000

var move_speed: float = 160
var vertical_speed: float = 0
var horizontal_speed: float = 0

var allow_move: bool = true
var allow_turn: bool = true


func _init_signals():
    sensor.detector_area.body_entered.connect(on_env_body_entered)
    main.START_JUMP.connect(on_start_jump)
    main.START_WALL_JUMP.connect(on_start_wall_jump)
    main.START_LAND_GROUND.connect(on_start_land_ground)
    main.START_LAND_WALL.connect(on_start_land_wall)
    main.START_ROLL.connect(on_start_roll)
    main.STOP_ROLL.connect(on_stop_roll)
    main.START_RUN.connect(on_start_run)
    main.STOP_RUN.connect(on_stop_run)
    #main.START_SPRINT_RUN.connect(on_start_sprint_run)
    #main.STOP_SPRINT_RUN.connect(on_stop_sprint_run)
    #main.START_SLIDE_TACKLE
    #main.STOP_SLIDE_TACKLE


func _physics_process(delta: float) -> void:
    if not sensor.is_on_ground or vertical_speed > 0:
        vertical_speed -= delta * Vars.gravity
    else:
        vertical_speed = 0
    if abs(horizontal_speed) > 0.1:
        if horizontal_speed > 0:
            horizontal_speed -= delta * Vars.gravity
        else:
            horizontal_speed += delta * Vars.gravity
    else:
        horizontal_speed = 0


func update_movement(delta: float):
    if state.move_state == PlayerFSM.MoveState.RollDodge:
        move_speed = max_roll_speed
    else:
        move_speed = max_sprint_speed if input.ctl_is_sprint_long_press else max_run_speed
    main.velocity = Vector2(input.ctl_move_direction, 0) * move_speed - Vector2(0, vertical_speed) + Vector2(horizontal_speed, 0)
    
    if allow_turn:
        if input.ctl_move_direction > 0:
            main.facing = Enums.Direction.Left
        elif input.ctl_move_direction < 0:
            main.facing = Enums.Direction.Right

func on_env_body_entered(body):
    if vertical_speed > 0:
        vertical_speed = 0


func on_start_jump():
    vertical_speed = ground_jump_init_speed
    sensor.mute_wall(0.2)
    
func on_start_wall_jump():
    vertical_speed = ground_jump_init_speed
    sensor.mute_wall(0.1)
    if sensor.is_on_wall_type == PlayerSensor.SensorWallType.Left:
        if input.ctl_move_direction < 0:
            horizontal_speed = wall_jump_init_speed
        else:
            horizontal_speed = -wall_zig_init_speed
    elif sensor.is_on_wall_type == PlayerSensor.SensorWallType.Right:
        if input.ctl_move_direction > 0:
            horizontal_speed = -wall_jump_init_speed
        else:
            horizontal_speed = wall_zig_init_speed
        
    
func on_start_land_ground():
    vertical_speed = 0
    
func on_start_land_wall():
    vertical_speed = wall_slide_speed

func on_start_roll():
    pass
    
func on_stop_roll():
    pass
    
func on_start_run():
    pass
    
func on_stop_run():
    pass
    
