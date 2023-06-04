-module(geradorDeAgua).
-export([start/1, correioLigacoes/3, gerar_oxigenio/1, gerar_hidrogenio/1, gerador/3]).

start(Intervalo) -> 
  spawn(geradorDeAgua, gerador, [Intervalo, 1, self()]),
  correioLigacoes(nada, nada, nada).

%--> Gerador de moleculas <--%
% Caso for a primeira chamada do gerador imprime que iniciou o gerador %
gerador(Intervalo, 1, PidCorreio) ->
  io:format("GERADOR - Iniciado ~n", []),
  gerador(Intervalo, 0, PidCorreio);
% Gera um oxigenio e um hidrogenio aguardando tempo de sleep e chama novamente o gerador recursivamente %
gerador(Intervalo, 0, PidCorreio) ->
  spawn(geradorDeAgua, gerar_oxigenio, [PidCorreio]),
  timer:sleep(Intervalo),
  spawn(geradorDeAgua, gerar_hidrogenio, [PidCorreio]),
  timer:sleep(Intervalo),
  gerador(Intervalo, 0, PidCorreio).

%--> Gera oxigenio <--%
gerar_oxigenio(PidCorreio) -> 
  %io:format("OXIGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  timer:sleep(Tempo),
  PidCorreio ! {oxigenio, self()}.

%--> Gera hidrogenio <--%
gerar_hidrogenio(PidCorreio) -> 
  %io:format("HIDROGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  timer:sleep(Tempo),
  PidCorreio ! {hidrogenio, self()}.


%--> Correio <--%

% Primeira iteração %
correioLigacoes(nada, nada, nada) ->
  receive 
		{oxigenio, PidOx} -> 
      % io:format("CORREIO - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes(nada, nada, {oxigenio, PidOx});
		{hidrogenio, PidHi} -> 
      % io:format("CORREIO - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHi}, nada, nada)
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

% Segunda possivel iteração %
correioLigacoes(nada, nada, {oxigenio, PidOXParam}) -> % __O
  receive 
		{hidrogenio, PidHi} -> 
      % io:format("CORREIO O__ - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHi}, nada ,{oxigenio, PidOXParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

% Segunda possivel iteração %
correioLigacoes({hidrogenio, PidHiParam}, nada, nada) -> % H__
  receive 
		{oxigenio, PidOx} -> 
      % io:format("CORREIO H__ - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes({hidrogenio, PidHiParam}, nada, {oxigenio, PidOx});
		{hidrogenio, PidHi} ->
      % io:format("CORREIO H__ - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi}, nada)
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

% Terceira possivel iteração %
correioLigacoes({hidrogenio, PidHiParam}, nada , {oxigenio, PidOxParam}) -> % H_O
  receive 
		{hidrogenio, PidHi} -> 
      % io:format("CORREIO H_O- hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi} , {oxigenio, PidOxParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

% Terceira possivel iteração %
correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, nada) -> %HH_
  receive 
		{oxigenio, PidOx} -> 
      % io:format("CORREIO HH_ - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, {oxigenio, PidOx})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

% Ultima iteração %
% Imprime que a agua foi gerada com os pids e chama recursivamente o correio para receber uma nova primeira iteração %
correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, {oxigenio, PidOxParam}) -> %HHO
  io:format("AGUA FOI GERADO COM AS SEGUINTES MOLECULAS ~n HIDROGENIO - ~p ~n HIDROGENIO - ~p ~n OXIGENIO - ~p ~n", 
    [PidHiParam1, PidHiParam2, PidOxParam]),
  correioLigacoes(nada, nada, nada).