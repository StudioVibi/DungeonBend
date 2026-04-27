Quero alterar a tela de seleção de personagem. Vamos ajustar tanto no desktop quanto no mobile?

Atualmente a tela é assim:

```
   ┌───────────────────────────────────────────────────────────────────────┐
   │  GOLD: 0000                                             BOOSTERS: 0   │
   │                                                                       │
   │                                                                       │
   │               ┌────────┐          HERO NAME                           │
   │               │        │        LV: 00 HP / HP                        │
   │               │ HERO   │       EQUIPPED/PREVIEW                       │
   │               │        │    ULTIMATE                                  │
   │               │ IMG    │    ┌─────┐ ULTIMATE DESCRIPTION              │
   │               │        │    │     │                                   │
   │               └────────┘    └─────┘                                   │
   │                                                                       │
   │                   [ UPGRADE BTN / LEVEL MAX TEXT ]                    │
   │                                                                       │
   │     ┌────────┐   ┌────────┐                                           │
   │     │        │   │        │                                           │
   │     │        │   │        │                                           │
   │     │        │   │        │                                           │
   │     └────────┘   └────────┘                                           │
   │                                                                       │
   │  [ BACK ]           [ SELECT/SELECTED BUTTON ]                        │
   └───────────────────────────────────────────────────────────────────────┘
```



- O texto de contador de booster nessa tela não faz sentido, pode remover.
- Não vai mais ter essa parada de selecionar um personagem e ainda precisar clicar em SELECT, acho que esse passo extra pode ser redundante. Uma borda verde em volta do selecionado.
- As infos na coluna de informacões do heroi são centralizadas o que deixa organizado, deveria estar alinhado na esquerda
- Equipped/preview nada a ver tbm pode remover

Versão mobile:

```
                      ┌─────────────────────────────────┐
                      │GOLD: 0000                       │
                      │                                 │
                      │                                 │
                      │ ┌───────────┐                   │
                      │ │           │HERO NAME          │
                      │ │           │Short lore.        │
                      │ │   HERO    │                   │
                      │ │           │LV: 01/maxLv HP 00 │
                      │ │   IMG     │┌───┐              │
                      │ │           ││   │ult descript. │
                      │ │           │└───┘              │
                      │ │           │    (upg price)    │
                      │ └───────────┘    [ UPGRADE ]    │
                      │                                 │
                      │  ┌─────┐ ┌─────┐                │
                      │  │     │ │     │                │
                      │  │     │ │     │                │
                      │  └─────┘ └─────┘                │
                      │                                 │
                      │                                 │
                      │          CTA TEXT AREA          │
                      │          [ CTA BUTTON ]         │
                      │                                 │
                      │                                 │
                      │[ BACK ]                         │
                      └─────────────────────────────────┘
```
```
 ┌────────────────────────────────────────────────────────────────────────────┐
 │ [ BACK ]                                                        GOLD: 0000 │
 │                                                                            │
 │                                                     │                      │
 │                                                     │ ┌─────┐┌─────┐       │
 │                                                     │ │     ││     │       │
 │                                                     │ │     ││     │       │
 │        ┌────────────────┐                           │ └─────┘└─────┘       │
 │        │                │    HERO NAME              │                      │
 │        │                │    Short lore.            │                      │
 │        │    HERO        │    LV: 01/maxLv   HP 00   │                      │
 │        │                │                           │                      │
 │        │    IMG         │                           │                      │
 │        │                │    ┌───┐                  │                      │
 │        │                │    │   │ ult descript.    │                      │
 │        │                │    └───┘                  │                      │
 │        │                │                           │                      │
 │        │                │                           │                      │
 │        │                │     (upg price)           │    CTA TEXT AREA     │
 │        └────────────────┘     [ UPGRADE ]           │    [ CTA BUTTON ]    │
 │                                                     │                      │
 │                                                     │                      │
 │                                                     │                      │
 │                                                     │                      │
 │                                                                            │
 │                                                                            │
 └────────────────────────────────────────────────────────────────────────────┘
```


Detalhes não muito explicitos no mockup:

- O sprite do personagem agora é maior e mais predominante na cena

- Hoje, o campo de HP, ao lado do level, mostra igual na dungeon = vida atual/vida máxima, mas nessa tela isso não faz sentido, deveriamos mostrar apenas o HP base do herói.

- CTA text: um texto curto falando pra desbloquear mais persoagens, um tom neutro tipo cinza. O botão CTA deve levar o usuário pra tela de boosters. (Aproveita essa implementação pra observar como estão os botoes de voltar, se tem caminho fixo ou se pega a ultima tela por exemplo, caminho fixo é mais recomendado considernado o flow de telas atuais certo? ou nao?)

- Sobre o campo de level, de forma dinamica, quero que mostra o level atual considerando upgrades do usuario / a quantia máxima de upgrades disponiveis

- Na grid que mostra os personagens disponiveis, eu quero que dentro dos cards de cada personagem, tenha o nível atual e o nivel máximo na parte de baixo, tipo assim:
```
    ┌───────────┐
    │           │
    │           │
    │           │
    │           │
    ├───────────┤
    │   01/05   │
    └───────────┘
```

Me peça mais referencias se tiver algo ambiguo ou que não ta 100% definido por favor pergunte e me envie referencias com mockups ASCII pra exemplificar. Nao assuma nada