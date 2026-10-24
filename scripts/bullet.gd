extends Area2D
class_name Bullet

@export var speed: float = 650.0
@export var damage: int = 1

var direction: Vector2 = Vector2.UP

func _ready() -> void:
    add_to_group("bullets")

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
