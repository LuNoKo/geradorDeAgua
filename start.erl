-module(start).
-export([start/1, correio/0, gerar_oxigenio/1, gerar_hidrogenio/1]).

start(Intervalo) -> 
  gerador(Intervalo),
  correio().

correio() ->
  receive 
		{oxigenio, PidOx} -> io:format("CORREIO - oxigenio pronto com pid: ~w ~n", 
      [PidOx]);
		{hidrogenio, PidHi} -> io:format("CORREIO - hidrogenio pronto com pid: ~w ~n", 
      [PidHi])
	end,
correio().

% Gerador de moleculas %
gerador(Intervalo) ->
  io:format("GERADOR - Iniciado ~n", []),
  spawn(start, gerar_oxigenio, [self()]),
  timer:sleep(Intervalo),
  spawn(start, gerar_hidrogenio, [self()]).
  gerador(Intervalo).

gerar_oxigenio(PidCorreio) -> 
  io:format("OXIGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  io:format("OXIGENIO - Tempo ~w ~n", [Tempo]),
  timer:sleep(Tempo),
  PidCorreio ! {oxigenio, self()}.

gerar_hidrogenio(PidCorreio) -> 
  io:format("HIDROGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  io:format("HIDROGENIO - Tempo ~w ~n", [Tempo]),
  timer:sleep(Tempo),
  PidCorreio ! {hidrogenio, self()}.