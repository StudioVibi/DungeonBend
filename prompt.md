Atualmente a UI do menu principal do meu jogo é assim:

```
   ┌───────────────────────────────────────────────────────────┐
   │                                                           │
   │ GOLD: 0000                      BOOSTER: 0 [ CHARACTERS ] │
   │                                                           │
   │                                                           │
   │                        char's name                        │
   │                        ┌────────┐                         │
   │                        │        │                         │
   │                        │        │                         │
   │                        │        │                         │
   │                        │        │                         │
   │                        └────────┘                         │
   │                    LV: X    HP: HP/MAX                    │
   │                                                           │
   │                      [ TESTAR FX ]                        │
   │                       [ BOOSTER ]                         │
   │                       [  START  ]                         │
   └───────────────────────────────────────────────────────────┘
```

Quero atualizar ela para explorar mais o espaço da tela e também melhorar os pontos UX wise:

```
   ┌───────────────────────────────────────────────────────────┐
   │                                                           │
   │                                                GOLD: 0000 │
   │                                                           │
   │                                                           │
   │                                                           │
   │                      LV: X    HP: Y                       │
   │                       ┌──────────┐                        │
   │                       │          │                        │
   │                ┌─────┐│          │                        │
   │                │* upg││          │                        │
   │                └─────┘│          │                        │
   │                       │          │                        │
   │                       └──────────┘                        │
   │                                                           │
   │         [05]                                     [ DECK ] │
   │ [ BOOSTER ]                                   [  START  ] │
   └───────────────────────────────────────────────────────────┘
```


Detalhes não muito explicitos no mockup:

- O sprite do personagem agora é maior e mais predominante na cena

- Hoje, o campo de HP, ao lado do level, mostra igual na dungeon = vida atual/vida máxima, mas nessa tela isso não faz sentido, deveriamos mostrar apenas o HP base do herói.

- O botão "deck" representa uma feature futura ainda não implementada mas quero que o botão exista no layout mesmo assim

- * upg = botão de upgrade. Atualmente tem um shortcut na tela inicial que permite o jogador apertar o botão de upgrade e dar level up no personagem por ali mesmo. eu quero alterar isso, tanto em posicionamento, quanto em funcionalidade.
    --> o que muda no posicionamento: atualmente o botão aparece em baixo do personagem. quero que esse botão apareça na lateral esquerda dele, não totalmente do lado, do lado e um pouco em cima da imagem, como um overlay.
    --> o que muda na funcionalidade: não quero que o jogador possa fazer o upgrade ao clicar no botão como é hoje. quando o botão de upgrade aparecer e o usuário clicar, quero que ele seja redirecionado para a tela de personagens, e de lá faça o upgrade.

- Booster: na UI atual da main screen tem dois elementos relacionados aos Boosters: contador de inventário que mostra a quantia que o usuário tem, e um botão que leva pra cena de booster. Queria tentar unificar esses dois, mas no mockup ASCII que eu fiz ficou parecendo uma bolinha de notificação, nao sei se isso é interessante UX wise, mas definitivamente não quero também como é hoje. Thoughts?

- O botão teste FX, você pode remover mas manter a tela de teste existente ainda caso eu precise testar novamente no futuro, apenas tire ele da tela principal.

- O botão "characters" vai ser 100% removido, ele era responsavel por levar o usuário a tela de seleção de personagens, mas quero fazer um teste novo: usar um evento de hover, que, ao passar o mouse por cima do personagem, aparece um texto em cima "CHANGE HERO"
    --> isso cria um edge case pra versão mobile que não tem onhover, então no mobile pode manter o botão por enquanto, depois vou pensar exatamente em como a tela do mobile tem que ser.
    --> eu gostaria que tivesse uma animação especifica no momento que esse texto "CHANGE HERO" for ser renderizado, uma faixa preta aparece atrás do texto, em forma de animação, indo do inicio ao fim, como se fosse um marcador de texto grifando. Pode deixar a cor de texto branca inicialmente. Btw: estou começando a explorar esses polimentos de interface/pequenos juices, mas gostaria que você ja deixasse organizado, não sei se o ideal é uma folha de estilos pra cada página, ou sei la, vamos conversar sobre isso pensando no futuro onde vou aos poucos aplicando pequenas animacoes em tudo.
        > aqui o mockup de ref de como to imaginando, esse texto, durante o onhover, tomaria o lugar que normalmente mostra os stats do personagem de nivel e hp:
```
   ┌───────────────────────────────────────────────────────────┐
   │                                                           │
   │                                                GOLD: 0000 │
   │                                                           │
   │                    [ CHANGE CHARACTER ]                   │
   │                                                           │
   │                      LV: X    HP: Y                       │
   │                       ┌──────────┐                        │
   │                       │          │                        │
   │                ┌─────┐│          │                        │
   │                │* upg││          │                        │
   │                └─────┘│          │                        │
   │                       │          │                        │
   │                       └──────────┘                        │
   │                                                           │
   │         [05]                                     [ DECK ] │
   │ [ BOOSTER ]                                   [  START  ] │
   └───────────────────────────────────────────────────────────┘
```


> Não quero que você crie envolopagem, css, elementos visuais, background, enfim, nada visualmente novo, vamos focar apenas no posicionamento do que ja existe.

> Não assuma nada, se tiver alguma dúvida por favor me pergunte

> Use apenas a linguagem Bend2, nada de js, ts, pyton, ou qualquer outra lang pra fazer essa iteração


