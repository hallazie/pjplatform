class_name Player extends Pawn

@onready var state: PlayerFSM = $FSM
@onready var sensor: PlayerSensor = $Sensor
@onready var input: PlayerInput = $Input
@onready var movement: PlayerMovement = $Movement
@onready var animator: PlayerAnimator = $Animator
@onready var weapon: PlayerWeapon = $Weapon 

var vertical_speed: float = 0
var horizontal_speed: float = 0
var gravity: float = 1200


func _ready() -> void:
    _init_component()
    _init_signals()
    
    
func _init_component():
    animator.main = self
    animator._init_signals()
    
    state.main = self
    state._init_signals()
    
    input.main = self
    input._init_signals()
    
    movement.main = self
    movement._init_signals()
    
    sensor.main = self
    sensor._init_signals()
    
    weapon.main = self
    weapon._init_signals()
    

func _init_signals():
    sensor.detector_area.body_entered.connect(on_body_entered)


func _process(delta: float) -> void:
    input.update_input(delta)
    sensor.update_sensor(delta)
    if input.ctl_jump_start and input.allow_jump:
        vertical_speed = 400
        sensor.mute_wall(0.2)
        if sensor.on_wall_type == PlayerSensor.OnWallType.Left and input.ctl_move_direction < 0:
            horizontal_speed = 400
        elif sensor.on_wall_type == PlayerSensor.OnWallType.Right and input.ctl_move_direction > 0:
            horizontal_speed = -400
    elif sensor.on_wall_type == PlayerSensor.OnWallType.Left and input.ctl_move_direction < 0:
        vertical_speed = -80
    elif sensor.on_wall_type == PlayerSensor.OnWallType.Right and input.ctl_move_direction > 0:
        vertical_speed = -80        
    velocity = Vector2(input.ctl_move_direction, 0) * 160 - Vector2(0, vertical_speed) + Vector2(horizontal_speed, 0)
    
    if sensor.on_wall_type != PlayerSensor.OnWallType.None and not sensor.is_on_ground:
        animator.upperbody.play("WallSlide")
    else:
        if vertical_speed > 0:
            animator.upperbody.play("JumpUp")
        elif vertical_speed < 0:
            animator.upperbody.play("JumpDown")
        else:
            if velocity != Vector2.ZERO:
                animator.upperbody.play("Run")
            else:
                animator.upperbody.play("Idle")
        
    
    if velocity.x < 0:
        animator.scale = Vector2(-1, 1)
    else:
        animator.scale = Vector2(1, 1)
    
    
func _physics_process(delta: float) -> void:
    if not sensor.is_on_ground or vertical_speed > 0:
        vertical_speed -= delta * gravity
    else:
        vertical_speed = 0
    if abs(horizontal_speed) > 0.1:
        if horizontal_speed > 0:
            horizontal_speed -= delta * 1200
        else:
            horizontal_speed += delta * 1200
    else:
        horizontal_speed = 0
    move_and_slide()


func on_body_entered(body):
    if vertical_speed > 0:
        vertical_speed = 0
