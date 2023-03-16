README

Este é um parser (analisador) do log do jogo Quake.

Como fazer o setup da Aplicação?

Deve-se executar a aplicação no terminal o comando: ruby parser-log.rb;
Logo, aparecerá o seguinte menu de opções para visualização das informações colhidas a partir do arquivo games.log:

O que deseja ver?
Digite 1 para exibir as informações de determinado jogo.
Digite 2 para exibir o relatorio de kills e causas dos abates por jogo.
Digite 3 para exibir o ranking geral de kills dos players.
Digite 4 para gerar o arquivo de relatorio dos jogos (ver na pasta log).
Digite 0 para finalizar a aplicação.

A partir da opção escolhida, temos:

Resultado da TASK 1 e 3

Para obter o resultado da task 1 e 3, basta escolher a opção 1 do menu.
Exemplo: Digitou 1, escolheu o jogo de número 5 ou ID 5. Obtém-se as seguintes informações com o resultado do game por ID:
Game_5 : {
 Total_kills: 14,
 Players : ["Dono da Bola", "Isgalamido", "Zeh", "Assasinu Credi" ]
 Kills: {
  Dono da Bola : 0
  Isgalamido : 2
  Zeh : 1
  Assasinu Credi: 1 
 }
}

Resultado da TASK 2

Para obter o resultado da task 2, basta escolher a opção 4 do menu.
Dessa forma, será gerado um relatório que exibe as informações gerais de cada jogo e um ranking geral de kills por jogador. O relatório será gerado no diretório log, arquivo de nome “resultado.log”.

Amostra do resultado obtido:
RANKING:
PLAYER: Isgalamido 150 KILLS
PLAYER: Zeh 124 KILLS
PLAYER: Oootsimo 114 KILLS
PLAYER: Assasinu Credi 111 KILLS
PLAYER: Dono da Bola 60 KILLS
PLAYER: Chessus 33 KILLS
PLAYER: Fasano Again 0 KILLS
PLAYER: UnnamedPlayer 0 KILLS
PLAYER: Chessus! 0 KILLS
PLAYER: Mocinha 0 KILLS
PLAYER: Maluquinho 0 KILLS
PLAYER: Mal -3 KILLS

Game 1:
PLAYER: Isgalamido 0 KILLS

Causas dos Abates:

Game 2:
PLAYER: Isgalamido -3 KILLS
PLAYER: Dono da Bola 0 KILLS
PLAYER: Mocinha 0 KILLS

Causas dos Abates:
Motivo: MOD_TRIGGER_HURT 7 vezes
Motivo: MOD_ROCKET_SPLASH 3 vezes
Motivo: MOD_FALLING 1 vezes

Entendendo o Arquivo Log Disponibilizado

Por meio do arquivo log (games.log) disponibilizado foi possível analisar os eventos repetitivos que ocorrem ao longo das partidas e deduzir os seguintes conceitos:

InitGame: indica o início da partida;

ClientConnect / ClientUserinfoChanged / ClientBegin: indica eventos referentes ao jogador, isto é, que o jogador se conectou, definiu suas informações e iniciou a partida; Uma vez que o jogador tenha entrado na partida, ele recebe um número e um nome identificador, como no exemplo a seguir:
20:38 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\uriel/zael\hmodel
Sendo 2 o número identificador e “Isgalamido” o nome do jogador;
Item: evento que registra a utilização de armas, utensílios e roupas de guerra pelo jogador;
 20:40 Item: 2 weapon_rocketlauncher
 20:40 Item: 2 ammo_rockets
 20:42 Item: 2 item_armor_body

Kill: evento que indica a morte de um jogador. Neste evento aparecem os números identificadores do jogador que matou e do jogador que foi morto, além do tipo de morte. Exemplo:
22:06 Kill: 2 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH
Sendo 2 o número identificador de “Isgalamido”, 3 o número identificador de “Mocinha” e 7 o tipo de morte “MOD_ROCKET_SPLASH”;

ShutdownGame: evento que indica o término da partida.

Solução Proposta da Aplicação

A linguagem utilizada para a aplicação foi ruby.
Após a análise, foi possível elaborar a estrutura de como o programa iria salvar as informações. Sendo assim, foram criadas as seguintes classes dentro da pasta de biblioteca “lib”:

game: contém o método que inicializa e faz a contagem do game por id; o método que faz as contagens das mortes; e o método que passa as informações sobre o jogo:
Game (id): {
Total_kills:
Players:
Kills: { player1: contagem de kills
	      player2: contagem de kills
	      player3: contagem de kills…..}
}

player: dentro da classe player, foram criados os métodos que inicializam e realizam as contagens de kills de cada jogador.

parser: classe necessária para realizar o parser (analisador) do log. Nela, são carregadas as classes game e player e contém o método responsável por ler o arquivo “games.log”, separá-lo em um array de strings, contendo cada linha gerada pelo log. Também contém os métodos para gerar todas as informações a partir do que foi coletado, isto é, a informação do jogo por id, relatório dos jogos, ranking geral de kills (abates), etc. Para isso são definidas as formas como cada informação do log é recolhida, conforme descrito abaixo:
jogador: /((?<=n\\).*?(?=\\t))/
quem executou a kill: /([^:]+).(?=\skilled)/
quem recebeu a kill: /((?<=killed\s).*(?=\sby))/
causa da morte: /((?<=by\s).*)/
início de novo jogo: /(?:^|\W)InitGame(?:$|\W)/
nome do jogador: /(?:^|\W)ClientUserinfoChanged(?:$|\W)/
fim de jogo: /(?:^|\W)ShutdownGame(?:$|\W)/
morte: /(?:^|\W)Kill(?:$|\W)/

Além dos arquivos das classes, foi criado o arquivo principal “parser-log.rb” que contém o menu de opções e organiza as informações e contagens realizadas para passar para o usuário.
