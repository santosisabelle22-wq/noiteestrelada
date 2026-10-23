# Planejamento de Software — Noite Estrelada: Resgate Lunar

**Versão:** 1.0
**Data:** 23/10/2026
**Status:** Em planejamento (pré-produção)

---

## 1. Visão geral

| Item | Definição |
|---|---|
| **Título** | Noite Estrelada: Resgate Lunar |
| **Gênero** | Shoot 'em up 2D (bullet hell leve) com progressão por fases |
| **Plataformas** | PC (Windows/Linux/macOS) e Web (WebGL); mobile em versão futura |
| **Público-alvo** | 10–30 anos, fãs de shmups clássicos e de estética pixel art |
| **Modo** | Single player |
| **Sessão média** | 25–40 minutos (campanha completa) |

### 1.1 Pilares de design

1. **Ação legível** — muitos projéteis na tela, mas sempre com leitura clara do perigo.
2. **Progressão de poder** — upgrades de tiro que mudam visivelmente o ritmo do combate.
3. **Contraste luz × escuridão** — identidade visual e sonora que reforça a narrativa.
4. **Curva de dificuldade justa** — o jogador aprende com a morte, não com a frustração.

---

## 2. Narrativa

### 2.1 Premissa

Em um universo onde a luz é mantida pela Lua e por sua Rainha, a Rainha da Escuridão decide
apagar toda e qualquer fonte de luz. Ela captura a Rainha da Lua e se instala em **Mercúrio**,
cercando-se de guardiões corrompidos. Miranda Margot, a Guerreira das Estrelas, parte sozinha
para resgatar sua soberana.

### 2.2 Personagens

| Personagem | Papel | Descrição |
|---|---|---|
| **Miranda Margot** | Protagonista jogável | Guerreira estelar com armadura prateada e detalhes dourados, cabelos longos azul-prateados, propulsores de energia |
| **Rainha da Lua** | NPC a ser resgatada | Fonte da luz do universo, aprisionada no covil; motiva toda a jornada |
| **Rainha da Escuridão** | Antagonista final | Figura imponente de energia negra com aura violeta; quer extinguir a luz |
| **Guardião de Mercúrio** | Chefe intermediário | Colosso corrompido que protege a entrada do covil |
| **Aliens Meteóricos** | Inimigos comuns | Naves orgânicas corrompidas que disparam munição de meteoro |

### 2.3 Estrutura narrativa

1. **Prólogo** — cutscene curta: a captura da Rainha da Lua.
2. **Travessia espacial** — Miranda abre caminho pelas hordas alienígenas.
3. **Chegada a Mercúrio** — aproximação e pouso forçado.
4. **Infiltração** — confronto com os guardiões de Mercúrio.
5. **Confronto final** — batalha contra a Rainha da Escuridão.
6. **Epílogo** — resgate e restauração da luz.

A narrativa é contada por **cutscenes curtas (10–20 s)** entre fases e por **diálogos em texto**
antes de cada chefe — sem longas interrupções do gameplay.

---

## 3. Gameplay

### 3.1 Loop principal

```
Sobreviver à onda → destruir inimigos → coletar power-ups → enfrentar chefe → avançar de fase
```

### 3.2 Controles

| Ação | Teclado | Gamepad | Touch (futuro) |
|---|---|---|---|
| Mover | WASD / Setas | Analógico esquerdo | Arraste |
| Atirar | Espaço (ou automático) | Botão A | Automático |
| Bomba Estelar | Shift | Botão B | Botão na tela |
| Pausar | Esc | Start | Botão na tela |

**Decisão de design:** tiro **automático** por padrão (segurável no menu), para que a atenção do
jogador fique na esquiva — padrão consolidado no gênero.

### 3.3 Sistemas centrais

| Sistema | Descrição | Prioridade |
|---|---|---|
| Input Manager | Teclado, gamepad e touch mapeados por ação | Alta |
| Player Controller | Movimento com aceleração suave, tiro, dano e invencibilidade temporária | Alta |
| Enemy Spawner | Ondas guiadas por tabelas de dados (timeline por fase) | Alta |
| Bullet Pooling | Pool de projéteis para evitar alocação em runtime | Alta |
| Collision System | Hitboxes circulares pequenas para o jogador, generosas para inimigos | Alta |
| Boss AI | Máquina de estados com padrões de ataque em fases | Alta |
| Power-up System | Drop por tabela de chance e efeito temporário | Média |
| UI/HUD | Vida, pontuação, vidas, bombas, indicador de chefe | Alta |
| Audio Manager | Música por camada e SFX com limite de vozes | Alta |
| Save System | Fases desbloqueadas, recordes e configurações (JSON local) | Média |
| Juice | Screen shake, flash de hit, partículas, hitstop curto | Média |

### 3.4 Jogador

| Atributo | Valor inicial | Observação |
|---|---|---|
| Vida | 3 corações | Dano remove 1; invencibilidade de 1,5 s após o hit |
| Vidas | 3 | Reinício no checkpoint da fase |
| Bombas Estelares | 2 | Limpa projéteis e causa dano em área |
| Níveis de tiro | 1 a 4 | Aumentam com power-ups; perde 1 nível ao morrer |

### 3.5 Inimigos

| Inimigo | Comportamento | Ataque | HP |
|---|---|---|---|
| **Scout** | Formação em V, atravessa a tela | Tiro simples reto | 1 |
| **Artilheiro Meteórico** | Entra, para e dispara rajadas | Meteoro em 3 direções | 3 |
| **Kamikaze** | Persegue o jogador em alta velocidade | Colisão explosiva | 1 |
| **Torreta Corrompida** | Fixa no cenário | Tiro teleguiado lento | 4 |
| **Elite Corrompido** | Alterna entre padrões | Leque de projéteis | 8 |
| **Guardião de Mercúrio** (chefe) | 3 fases de padrão | Laser varredor, chuva de meteoros, invocação de scouts | 120 |
| **Rainha da Escuridão** (chefe final) | 4 fases de padrão | Anéis de projéteis, raios de escuridão, meteoro gigante | 200 |

### 3.6 Power-ups

| Item | Efeito | Duração |
|---|---|---|
| **Prisma Estelar** | +1 nível de tiro (até 4) | Permanente na fase |
| **Escudo Lunar** | Absorve 1 hit | Até ser consumido |
| **Cometa** | +40% velocidade | 10 s |
| **Bomba Estelar** | +1 bomba | Imediato |
| **Coração de Luz** | +1 vida | Imediato |
| **Estrela Cadente** | Pontos bônus | Imediato |

### 3.7 Fases

| Fase | Cenário | Foco de design | Duração alvo |
|---|---|---|---|
| **1** | Cinturão de asteroides | Tutorial implícito, scouts e artilheiros | 3 min |
| **2** | Campo de destroços | Densidade maior, kamikazes e elites | 4 min |
| **3** | Aproximação de Mercúrio | Transição visual, torretas e artilharia pesada | 4 min |
| **4** | Superfície corrompida | Guardião de Mercúrio (chefe intermediário) | 5 min |
| **5** | Covil da Escuridão | Escalada final e Rainha da Escuridão | 6 min |

### 3.8 Curva de dificuldade

- Densidade de inimigos cresce por fase, mas a velocidade dos projéteis cresce apenas 15% no total.
- Cada fase introduz **um** inimigo novo antes de combiná-lo com os anteriores.
- Modo **Acolhimento** (opcional): mais vidas, projéteis 20% mais lentos; não afeta recordes.

### 3.9 Pontuação

- Inimigo comum: 100 pts
- Elite: 500 pts
- Chefe: 5.000 pts
- Bônus de fim de fase: vida restante × 1.000 + bombas × 500
- Multiplicador de combo: sobe ao acertar sem levar dano (máx. ×3)

---

## 4. Direção de arte

### 4.1 Estilo

Pixel art 2D com resolução base **480×270**, paleta controlada (32–48 cores por fase) e leitura
silhuética forte. Animações de 6–8 frames para o jogador, 4 frames para inimigos comuns.

### 4.2 Paleta

| Cor | HEX | Uso |
|---|---|---|
| Azul Estelar | `#4A90E2` | Projéteis da Miranda, UI |
| Dourado Lunar | `#FFD700` | Rainha da Lua, itens raros |
| Violeta Cósmico | `#6B46C1` | Energia dos power-ups |
| Roxo Profundo | `#2D1B69` | Fundo espacial |
| Vermelho Corrompido | `#DC2626` | Inimigos e meteoros |
| Preto Abissal | `#0F0F23` | Covil, vinheta |
| Ciano Luminoso | `#06B6D4` | Escudos, efeitos |

### 4.3 Assets mínimos

| Categoria | Quantidade estimada |
|---|---|
| Sprites do jogador (idle, mover, dano, morte) | 5 animações |
| Inimigos comuns | 5 sprites + animações |
| Chefes | 2 sprites grandes (96×96 ou maior) |
| Projéteis e efeitos | 10 |
| Power-ups | 6 |
| Fundos em parallax | 3 camadas × 5 fases |
| UI (frames, ícones, fontes) | 1 conjunto |

### 4.4 UI/UX

- **HUD minimalista:** vida no canto superior esquerdo, pontuação à direita, bombas abaixo da vida.
- **Menu principal:** Jogar, Opções, Créditos, Sair.
- **Pause:** Continuar, Reiniciar fase, Menu principal.
- **Acessibilidade:** remapeamento de teclas, opção de reduzir flashes, escala de UI, legendas nas cutscenes.

---

## 5. Áudio

### 5.1 Trilha sonora

| Contexto | Estilo | Atmosfera |
|---|---|---|
| Menu | Orquestral cósmico | Majestoso e esperançoso |
| Fases 1–2 | Synthwave/chiptune energético | Ação crescente |
| Fases 3–4 | Orquestral sombrio com synth | Tensão e aproximação |
| Chefes | Metal sinfônico | Intenso |
| Confronto final | Orquestral em duas camadas (luz × trevas) | Clímax |
| Vitória / Game Over | Orquestral heroico / melancólico | Fechamento emocional |

### 5.2 SFX

Tiro, explosões (3 variações), hit no jogador, coleta de power-up, alerta de chefe, colisão de
meteoro, seleção de menu, bomba estelar, morte de chefe.

---

## 6. Especificações técnicas

### 6.1 Engine

**Recomendação: Godot Engine 4.3+ (GDScript).**

| Critério | Godot | Unity 2D | GameMaker | Phaser |
|---|---|---|---|---|
| Custo | Gratuito | Gratuito (limites) | Pago | Gratuito |
| Curva de aprendizado | Baixa | Média | Baixa | Média |
| 2D nativo | Sim | Bom | Excelente | Bom |
| Export WebGL | Sim | Sim | Limitado | Sim |
| Ideal para | Este projeto | Projetos grandes | Shmups | Protótipos web |

### 6.2 Arquitetura

```
.
├── docs/                 # Documentação
├── assets/
│   ├── sprites/
│   ├── audio/{music,sfx}/
│   └── fonts/
├── scenes/
│   ├── actors/{player,enemies,bosses}/
│   ├── levels/
│   ├── ui/
│   └── fx/
├── scripts/
│   ├── systems/          # spawner, pooling, save
│   └── data/             # recursos de dados (.tres)
└── autoloads/            # GameManager, AudioManager, SceneRouter
```

### 6.3 Padrões e decisões técnicas

- **Autoloads (singletons):** `GameManager` (estado global, score), `AudioManager`, `SceneRouter`.
- **Dados em Resources:** ondas e padrões de chefe definidos em arquivos `.tres`, nunca hardcoded.
- **Pooling:** projéteis e inimigos comuns reutilizados; zero `instantiate()` durante o combate.
- **Hitbox separada da sprite:** `Area2D` pequena no jogador (justiça) e ampla nos inimigos.
- **Física desnecessária:** colisões por `Area2D`, sem `RigidBody` (previsibilidade).
- **Determinismo de ondas:** timelines por tempo, com dificuldade opcional ajustando multiplicadores.
- **Resolução:** viewport 480×270, stretch `canvas_items`, aspect `keep`.
- **Orçamento de performance:** 60 FPS estáveis com até 300 projéteis e 40 inimigos ativos.

### 6.4 Save e configurações

Arquivo JSON em `user://save.json` com: fases desbloqueadas, recordes por fase, opções de áudio,
remapeamento de teclas e preferências de acessibilidade. Escrita atômica (arquivo temporário + rename).

---

## 7. Cronograma (10 semanas)

| Semana | Entrega | Marco |
|---|---|---|
| 1 | GDD finalizado, concept art, escolha da engine | Pré-produção |
| 2 | Setup do projeto, input, movimentação e tiro | — |
| 3 | Inimigos básicos, colisão, vida e morte | **Protótipo jogável** |
| 4 | Fase 1 completa com ondas e chefe simples | — |
| 5 | Arte final do jogador, inimigos e fundos | Produção |
| 6 | Fases 2 e 3 | — |
| 7 | Sistema de chefes, Guardião de Mercúrio | — |
| 8 | Fase 4, UI, menus, save | — |
| 9 | Fase 5, Rainha da Escuridão, trilha sonora | **Conteúdo completo** |
| 10 | Playtests, balanceamento, builds e publicação | **Lançamento** |

### 7.1 Equipe mínima

| Papel | Alocação |
|---|---|
| Programação | 1 pessoa (tempo integral) |
| Arte | 1 pessoa (meio período) |
| Áudio | 1 pessoa (freelance, semanas 8–9) |
| QA / playtest | Rotativo (semanas 9–10) |

**Projeto solo:** multiplicar o cronograma por ~1,8 (≈18 semanas).

---

## 8. Riscos e mitigações

| Risco | Prob. | Impacto | Mitigação |
|---|---|---|---|
| Scope creep | Alta | Alto | Congelar escopo no MVP; ideias novas vão para backlog pós-1.0 |
| Performance no WebGL | Média | Alto | Pooling, limite de partículas, teste de build web desde a semana 4 |
| Balanceamento frustrante | Alta | Alto | Playtest semanal com 3+ pessoas; telemetria simples de mortes |
| IA de chefe complexa | Média | Médio | Máquina de estados por fases, cada padrão testado isoladamente |
| Arte consumindo tempo | Alta | Médio | Reaproveitar paleta e silhuetas; protótipo com placeholders |
| Perda de progresso | Baixa | Alto | Versionamento em Git com commits pequenos e frequentes |

---

## 9. MVP e escopo

### 9.1 MVP (protótipo jogável)

- [ ] Movimento, tiro e colisão do jogador
- [ ] Inimigos básicos (scout, artilheiro, kamikaze)
- [ ] Vida, morte e reinício de fase
- [ ] Fase 1 com ondas e pontuação
- [ ] HUD e menu principal
- [ ] Placeholders de arte e som

### 9.2 Versão 1.0

- [ ] 5 fases completas
- [ ] 2 chefes com padrões em fases
- [ ] Todos os power-ups
- [ ] Arte final e trilha sonora completa
- [ ] Cutscenes de prólogo e epílogo
- [ ] Save, recordes e opções de acessibilidade
- [ ] Builds Windows, Linux e Web

### 9.3 Pós-lançamento

Novo game+ com dificuldade extra, modo boss rush, leaderboard online e fase bônus.

---

## 10. Testes e qualidade

| Tipo | O que valida | Frequência |
|---|---|---|
| Teste unitário (GUT) | Cálculo de dano, pontuação, save | A cada sistema novo |
| Playtest interno | Diversão, leitura de tela, dificuldade | Semanal |
| Playtest externo | Curva de aprendizado real | Semanas 6 e 9 |
| Teste de performance | FPS em pico de projéteis | Semanal a partir da semana 4 |
| Teste multiplataforma | Builds PC/Web | Antes de cada marco |

**Critério de aceite do MVP:** uma pessoa que nunca jogou consegue completar a Fase 1 em até
3 tentativas e entende os controles sem instrução externa.

---

## 11. Próximos passos

1. Escolher oficialmente a engine (recomendação: Godot 4.3+).
2. Produzir concept art de Miranda e da Rainha da Escuridão.
3. Implementar o protótipo da semana 2–3 (movimento, tiro, inimigos).
4. Definir se o scroll será **vertical** (recomendado para leitura de projéteis) ou lateral.
5. Configurar repositório, CI de export de builds e versionamento de assets.
