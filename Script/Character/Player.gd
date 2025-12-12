class_name Player extends Pawn

signal START_JUMP
signal START_WALL_JUMP
signal START_LAND_GROUND
signal START_LAND_WALL
signal START_ROLL
signal STOP_ROLL
signal START_RUN
signal STOP_RUN
signal START_SPRINT_RUN
signal STOP_SPRINT_RUN
signal START_SLIDE_TACKLE   
signal STOP_SLIDE_TACKLE


@onready var state: PlayerFSM = $FSM
@onready var sensor: PlayerSensor = $Sensor
@onready var input: PlayerInput = $Input
@onready var movement: PlayerMovement = $Movement
@onready var animator: PlayerAnimator = $Animator

var facing: Enums.Direction = Enums.Direction.Right


func _ready() -> void:
    _init_component()
    _init_signals()
    
    
func _init_component():
    animator.main = self
    animator.state = state
    animator.movement = movement
    animator.sensor = sensor
    animator._init_signals()
    
    state.main = self
    state.input = input
    state._init_signals()
    
    input.main = self
    input._init_signals()
    
    movement.main = self
    movement.state = state
    movement.input = input
    movement.sensor = sensor
    movement._init_signals()
    
    sensor.main = self
    sensor._init_signals()
    

func _init_signals():
    pass

func _process(delta: float) -> void:
    input.update_input(delta)
    sensor.update_sensor(delta)
    update_behaviour(delta)
    state.update_state(delta)
    movement.update_movement(delta)
    animator.update_animator(delta)
    move_and_slide()
    
func update_behaviour(delta: float):
    if input.ctl_jump_start and input.allow_jump:
        if sensor.is_on_wall_type != PlayerSensor.SensorWallType.None:
            START_WALL_JUMP.emit()
        else:
            START_JUMP.emit()
    elif sensor.is_on_ground and not sensor.is_on_ground_previous:
        START_LAND_GROUND.emit()
    elif sensor.is_on_wall_type != sensor.SensorWallType.None and sensor.is_on_wall_type_previous == sensor.SensorWallType.None:
        START_LAND_WALL.emit()
    elif input.ctl_move_direction != 0:
        if input.ctl_shift_release:
            if input.input_press[Enums.InputOption.Shift] < input.sprint_long_press_threshold:
                START_ROLL.emit()
            else:
                STOP_SPRINT_RUN.emit()
        elif input.ctl_shift_hold:
            if input.input_press[Enums.InputOption.Shift] - delta < input.sprint_long_press_threshold and input.input_press[Enums.InputOption.Shift] >= input.sprint_long_press_threshold:
                START_SPRINT_RUN.emit()
        elif input.ctl_move_start:
            START_RUN.emit()
    elif input.ctl_move_release:
        if input.input_press[Enums.InputOption.Shift] >= input.sprint_long_press_threshold:
            STOP_SPRINT_RUN.emit()
        else:
            STOP_RUN.emit()
    
    
func update_post():
    sensor.is_on_ground_previous = sensor.is_on_ground
    sensor.is_on_wall_type_previous = sensor.is_on_wall_type
    
    
