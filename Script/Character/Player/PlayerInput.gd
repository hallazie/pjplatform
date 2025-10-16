class_name PlayerInput extends Node2D

var main: Player = null

var allow_input: bool = true
var allow_move: bool = true
var allow_attack: bool = true
var allow_jump: bool = true
var allow_buff: bool = true

var input_cache: Dictionary = {}
var input_press: Dictionary = {}
var input_cache_max: float = 0.2            # 200 ms for all input cache

var ctl_move_hold: bool = false             # pressing
var ctl_move_start: bool = false            # just press
var ctl_attack_hold: bool = false
var ctl_attack_start: bool = false
var ctl_attack_release: bool = false
var ctl_mid_start: bool = false
var ctl_mid_hold: bool = false
var ctl_mid_release: bool = false
var ctl_right_start: bool = false
var ctl_right_hold: bool = false
var ctl_shift_start: bool = false
var ctl_shift_hold: bool = false
var ctl_shift_release: bool = false
var ctl_jump_start: bool = false
var ctl_jump_hold: bool = false
var ctl_jump_release: bool = false
var ctl_crouch: bool = false
var ctl_dash_strike_start: bool = false
var ctl_interact: bool = false
var ctl_detaching: bool = false
var ctl_move_direction: float = 0


func _ready() -> void:
    #for input_option in Enums.InputOption:
        #input_press[input_option] = 0
    input_press[Enums.InputOption.Space] = 0
    input_press[Enums.InputOption.Shift] = 0
    input_press[Enums.InputOption.LeftClick] = 0
    input_press[Enums.InputOption.MiddleClick] = 0
    

func _init_signals():
    pass


func update_input(delta):
    if not allow_input:
        input_cache.clear()
        return
    
    #var wheel_value = Input.get_axis("ScrollUp", "ScrollDown")
    #if wheel_value > 0:
        #main.weapon.pickable_index += 1
    #elif wheel_value < 0:
        #main.weapon.pickable_index -= 1

    ctl_attack_start = Input.is_action_just_pressed("MouseLeftClick")
    ctl_attack_hold = Input.is_action_pressed("MouseLeftClick")
    ctl_attack_release = Input.is_action_just_released("MouseLeftClick")
    if ctl_attack_hold:
        input_press[Enums.InputOption.LeftClick] += delta
    elif ctl_attack_release or ctl_attack_start:
        input_press[Enums.InputOption.LeftClick] = 0
    
    ctl_mid_start = Input.is_action_just_pressed("MouseMiddleClick")
    ctl_mid_hold = Input.is_action_pressed("MouseMidClick")
    ctl_mid_release = Input.is_action_just_released("MouseMidClick")
    if ctl_mid_hold:
        input_press[Enums.InputOption.MiddleClick] += delta
    elif ctl_mid_release or ctl_mid_start:
        input_press[Enums.InputOption.MiddleClick] = 0
        
    ctl_right_start = Input.is_action_just_pressed("MouseRightClick")
    ctl_right_hold = Input.is_action_pressed("MouseRightClick")

    ctl_move_start = Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right")
    ctl_move_hold = Input.is_action_pressed("Left") or Input.is_action_pressed("Right")
    
    ctl_shift_start = Input.is_action_just_pressed("Shift")
    ctl_shift_hold = Input.is_action_pressed("Shift")
    ctl_shift_release = Input.is_action_just_released("Shift")
    if ctl_shift_hold:
        input_press[Enums.InputOption.Shift] += delta
    elif ctl_shift_release or ctl_shift_start:
        input_press[Enums.InputOption.Shift] = 0
    
    ctl_jump_start = Input.is_action_just_pressed("Space")
    ctl_jump_hold = Input.is_action_pressed("Space")
    ctl_jump_release = Input.is_action_just_released("Space")
    if ctl_jump_hold:
        input_press[Enums.InputOption.Space] += delta
    elif ctl_jump_release or ctl_jump_start:
        input_press[Enums.InputOption.Space] = 0
    
    ctl_crouch = Input.is_action_just_pressed("C")
    ctl_interact = Input.is_action_just_pressed("E")
    ctl_detaching = Input.is_action_just_pressed("F")
    #ctl_shift_hold = Input.is_action_pressed("Shift")

    ctl_move_direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")

    for key in input_cache.keys():
        if input_cache[key] > 0:
            input_cache[key] -= delta
    
    allow_jump = main.sensor.is_on_ground or main.sensor.on_wall_type != PlayerSensor.OnWallType.None
