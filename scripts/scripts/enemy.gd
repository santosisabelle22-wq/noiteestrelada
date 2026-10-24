extends Area2D
class_name Enemy

signal defeated(points: int)

@export var speed: float = 100.0
@export var health: int = 2
@export var points: int = 100

var target_position: Vector2

func _ready() -> void:
    add_to_group("enemies")

func _physics_process(delta: float) -> void:
    position.y += speed * delta

func take_damage(amount: int) -> void:
    health -= amount

    if health <= 0:
        defeated.emit(points)
        queue_free()
