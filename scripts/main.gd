
extends Node2D

const LARGURA := 960.0
const ALTURA := 540.0
const VELOCIDADE := 320.0
const VELOCIDADE_TIRO := 520.0

var jogadora := Vector2(480.0, 450.0)
var tiros: Array[Vector2] = []
var inimigos: Array[Vector2] = []
var vidas := 3
var pontos := 0
var tempo_tiro := 0.0
var tempo_inimigo := 0.0
var fim_de_jogo := false

func _ready() -> void:
    randomize()
    queue_redraw()

func _process(delta: float) -> void:
    if fim_de_jogo:
        if Input.is_key_pressed(KEY_R):
            reiniciar()
        queue_redraw()
        return

    mover_jogadora(delta)

    tempo_tiro -= delta
    tempo_inimigo -= delta

    if Input.is_key_pressed(KEY_SPACE) and tempo_tiro <= 0.0:
        tiros.append(jogadora + Vector2(0, -22))
        tempo_tiro = 0.22

    if tempo_inimigo <= 0.0:
        inimigos.append(Vector2(randf_range(25, LARGURA - 25), -20))
        tempo_inimigo = 0.9

    for i in range(tiros.size() - 1, -1, -1):
        tiros[i].y -= VELOCIDADE_TIRO * delta
        if tiros[i].y < -10:
            tiros.remove_at(i)

    for i in range(inimigos.size() - 1, -1, -1):
        inimigos[i].y += 130.0 * delta

        if inimigos[i].y > ALTURA + 20:
            inimigos.remove_at(i)
            perder_vida()
            continue

        if inimigos[i].distance_to(jogadora) < 27:
            inimigos.remove_at(i)
            perder_vida()
            continue

        var acertou := false
        for j in range(tiros.size() - 1, -1, -1):
            if inimigos[i].distance_to(tiros[j]) < 22:
                tiros.remove_at(j)
                acertou = true
                break

        if acertou:
            inimigos.remove_at(i)
            pontos += 10

    queue_redraw()

func mover_jogadora(delta: float) -> void:
    var direcao := Vector2.ZERO

    if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
        direcao.x -= 1
    if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
        direcao.x += 1
    if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
        direcao.y -= 1
    if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
        direcao.y += 1

    if direcao.length() > 0:
        direcao = direcao.normalized()

    jogadora += direcao * VELOCIDADE * delta
    jogadora.x = clampf(jogadora.x, 20, LARGURA - 20)
    jogadora.y = clampf(jogadora.y, 35, ALTURA - 20)

func perder_vida() -> void:
    vidas -= 1
    if vidas <= 0:
        fim_de_jogo = true

func reiniciar() -> void:
    jogadora = Vector2(480, 450)
    tiros.clear()
    inimigos.clear()
    vidas = 3
    pontos = 0
    tempo_tiro = 0
    tempo_inimigo = 0
    fim_de_jogo = false

func _draw() -> void:
    draw_rect(Rect2(0, 0, LARGURA, ALTURA), Color("#080b24"))

    for i in range(90):
        var x := fmod(float(i * 137), LARGURA)
        var y := fmod(float(i * 79) + Time.get_ticks_msec() * 0.015, ALTURA)
        draw_circle(Vector2(x, y), 1.5, Color("#a9caff"))

    # Miranda: nave provisória em azul e dourado
    draw_colored_polygon(PackedVector2Array([
        jogadora + Vector2(0, -22),
        jogadora + Vector2(-17, 15),
        jogadora + Vector2(0, 9),
        jogadora + Vector2(17, 15)
    ]), Color("#76b9ff"))

    draw_circle(jogadora, 4, Color("#fff0a6"))

    for tiro in tiros:
        draw_line(tiro, tiro + Vector2(0, 12), Color("#80f7ff"), 4)

    for inimigo in inimigos:
        draw_colored_polygon(PackedVector2Array([
            inimigo + Vector2(0, 16),
            inimigo + Vector2(-15, -10),
            inimigo + Vector2(0, -5),
            inimigo + Vector2(15, -10)
        ]), Color("#e84d8a"))

    draw_string(ThemeDB.fallback_font, Vector2(20, 30),
        "NOITE ESTRELADA: RESGATE LUNAR", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(20, 57),
        "Pontos: %d" % pontos, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#ffe7a3"))
    draw_string(ThemeDB.fallback_font, Vector2(820, 30),
        "Vidas: %d" % vidas, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#ffb7d2"))
    draw_string(ThemeDB.fallback_font, Vector2(20, 520),
        "Mover: WASD/setas | Atirar: ESPACO", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#a9caff"))

    if fim_de_jogo:
        draw_rect(Rect2(0, 0, LARGURA, ALTURA), Color(0, 0, 0, 0.75))
        draw_string(ThemeDB.fallback_font, Vector2(330, 240),
            "FIM DE JOGO", HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color("#ffb7d2"))
        draw_string(ThemeDB.fallback_font, Vector2(285, 285),
            "Pressione R para reiniciar", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
