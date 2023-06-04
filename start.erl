-module(start).
-export([start/0, correioLigacoes/3, gerar_oxigenio/1, gerar_hidrogenio/1]).

start() -> 
  % correioStart(),
  % gerador(3000, 1).
  Intervalo = 3000,

  timer:sleep(Intervalo),
  spawn(start, gerar_oxigenio, [self()]),
  timer:sleep(Intervalo),
  spawn(start, gerar_hidrogenio, [self()]),
  timer:sleep(Intervalo),
  spawn(start, gerar_hidrogenio, [self()]),

  receive 
		{oxigenio, PidOx} -> 
      io:format("CORREIO - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes(nada, nada, {oxigenio, PidOx});
		{hidrogenio, PidHi} -> 
      io:format("CORREIO - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHi}, nada, nada)
	end,
  start().

gerar_oxigenio(PidCorreio) -> 
  io:format("OXIGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  timer:sleep(Tempo),
  PidCorreio ! {oxigenio, self()}.

gerar_hidrogenio(PidCorreio) -> 
  io:format("HIDROGENIO - Gerado pid ~w ~n", [self()]),
  Tempo = (rand:uniform(21) + 10) * 1000,
  timer:sleep(Tempo),
  PidCorreio ! {hidrogenio, self()}.


% correioLigacoes() -> % HHO
% correioLigacoes() -> % HOH
% correioLigacoes() -> % OHH
% correioLigacoes({hidrogenio, PidHi1}, {hidrogenio, PidHi1}, _) -> % HH_
% correioLigacoes({oxigenio, PidOx}, {hidrogenio, PidHi}, _) -> % OH_
% correioLigacoes({hidrogenio, PidHi}, {oxigenio, PidOx}, _) -> % HO_
%   receive 
% 		{oxigenio, PidOx} -> 
%       correioLigacoes({oxigenio, PidOx});
% 		{hidrogenio, PidHi} -> 
%       correioLigacoes({hidrogenio, PidHi})
% 	end;


correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, {oxigenio, PidOxParam}) ->
  io:format("AGUA FOI GERADO COM AS SEGUINTES MOLECULAS ~n HIDROGENIO - ~p ~n HIDROGENIO - ~p ~n OXIGENIO - ~p ~n", 
    [PidHiParam1, PidHiParam2, PidOxParam]);

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, nada) -> %HH_
  receive 
		{oxigenio, PidOx} -> 
      io:format("CORREIO HH_ - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, {oxigenio, PidOx})
		% {hidrogenio, PidHi} -> 
    %   correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi} , {oxigenio, PidOxParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({hidrogenio, PidHiParam}, nada , {oxigenio, PidOxParam}) -> % H_O
  receive 
		% {oxigenio, PidOx} -> 
    %   correioLigacoes({oxigenio, PidOx});
		{hidrogenio, PidHi} -> 
      io:format("CORREIO H_O- hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi} , {oxigenio, PidOxParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({hidrogenio, PidHiParam}, nada, nada) -> % H__
  receive 
		{oxigenio, PidOx} -> 
      io:format("CORREIO H__ - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes({hidrogenio, PidHiParam}, nada, {oxigenio, PidOx});
		{hidrogenio, PidHi} ->
      io:format("CORREIO H__ - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi}, nada)
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes(nada, nada, {oxigenio, PidOXParam}) -> % __O
  receive 
		% {oxigenio, PidOx} -> 
    %   correioLigacoes({oxigenio, PidOx}, {PidParamOX});
		{hidrogenio, PidHi} -> 
      io:format("CORREIO O__ - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHi}, nada ,{oxigenio, PidOXParam})
	end.