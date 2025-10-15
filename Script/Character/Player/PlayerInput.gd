class_name PlayerInput extends Node2D

var main: Player = null

var allow_input: bool = true
var allow_move: bool = true
var allow_attack: bool = true
var allow_jump: bool = true
var allow_buff: bool = true

var input_cache: Dictionary = {}
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
var ctl_jump_start: bool = false
var ctl_crouch: bool = false
var ctl_dash_strike_start: bool = false
var ctl_interact: bool = false
var ctl_detaching: bool = false
var ctl_shift_hold: bool = false
var ctl_switch_to_weapon_1: bool = false
var ctl_switch_to_weapon_2: bool = false
var ctl_switch_to_weapon_3: bool = false
var ctl_switch_to_weapon_4: bool = false
var ctl_move_direction: float = 0


func update_input(delta):
    #if not allow_input:
        #input_cache.clear()
        #return
    
    #if Input.is_action_just_pressed("MouseLeftClick") and allow_attack:
        #input_cache[Vars.InputOption.LeftClick] = input_cache_max
    #if Input.is_action_just_pressed("MouseMiddleClick") and allow_attack:
        #input_cache[Vars.InputOption.MiddleClick] = input_cache_max
    #if Input.is_action_just_pressed("MouseRightClick") and allow_attack: 
        #input_cache[Vars.InputOption.RightClick] = input_cache_max
    #if Input.is_action_just_pressed("Space") and allow_jump:
        #input_cache[Vars.InputOption.Space] = input_cache_max
    #if Input.is_action_just_pressed("Up") and allow_move:
        #input_cache[Vars.InputOption.W] = input_cache_max
    #if Input.is_action_just_pressed("Down") and allow_move:
        #input_cache[Vars.InputOption.S] = input_cache_max
    #if Input.is_action_just_pressed("Left") and allow_move:
        #input_cache[Vars.InputOption.A] = input_cache_max
    #if Input.is_action_just_pressed("Right") and allow_move:
        #input_cache[Vars.InputOption.D] = input_cache_max
    #if Input.is_action_just_pressed("Q") and allow_buff:
        #input_cache[Vars.InputOption.Q] = input_cache_max
    #if Input.is_action_just_pressed("E"):
        #input_cache[Vars.InputOption.E] = input_cache_max
    #if Input.is_action_just_pressed("C"):
        #input_cache[Vars.InputOption.C] = input_cache_max    
    #if Input.is_action_just_pressed("F"):
        #input_cache[Vars.InputOption.F] = input_cache_max        
    
    #var wheel_value = Input.get_axis("ScrollUp", "ScrollDown")
    #if wheel_value > 0:
        #main.weapon.pickable_index += 1
    #elif wheel_value < 0:
        #main.weapon.pickable_index -= 1

    ctl_attack_start = Input.is_action_just_pressed("MouseLeftClick") and allow_attack
    ctl_attack_hold = Input.is_action_pressed("MouseLeftClick") and allow_attack
    ctl_attack_release = Input.is_action_just_released("MouseLeftClick") and allow_attack
    
    ctl_mid_start = Input.is_action_just_pressed("MouseMiddleClick") and allow_attack
    ctl_mid_hold = Input.is_action_pressed("MouseMidClick") and allow_attack
    ctl_mid_release = Input.is_action_just_released("MouseMidClick") and allow_attack
    
    ctl_right_start = Input.is_action_just_pressed("MouseRightClick")
    ctl_right_hold = Input.is_action_pressed("MouseRightClick")

    ctl_move_start = Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right")
    ctl_move_hold = Input.is_action_pressed("Left") or Input.is_action_pressed("Right") or Input.is_action_pressed("Up") or Input.is_action_pressed("Down")
    
    ctl_crouch = Input.is_action_just_pressed("C")
    ctl_jump_start = Input.is_action_just_pressed("Space") and allow_jump
    ctl_interact = Input.is_action_just_pressed("E")
    ctl_detaching = Input.is_action_just_pressed("F")
    #ctl_shift_hold = Input.is_action_pressed("Shift")

    ctl_move_direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")

    if ctl_shift_hold:
        ctl_jump_start = false
    
    for key in input_cache.keys():
        if input_cache[key] > 0:
            input_cache[key] -= delta
    
    allow_jump = main.sensor.is_on_ground or main.sensor.on_wall_type != PlayerSensor.OnWallType.None
