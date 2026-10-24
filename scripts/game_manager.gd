extends Node
class_name GameManager

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_over

var score: int = 0
var lives: int = 3
var is_game_over: bool = false

func add_score(points: int) -> void:
    if is_game_over:
        return

    score += points
    score_changed.emit(score)

func lose_life() -> void:
    if is_game_over:
        return

    lives -= 1
    lives_changed.emit(lives)

    if lives <= 0:
        is_game_over = true
        game_over.emit()

func reset_game() -> void:
    score = 0
    lives = 3
    is_game_over = false

    score_changed.emit(score)
    lives_changed.emit(lives)
