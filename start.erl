-module(start).
-export([start/0, correioStart/0, correioLigacoes/3, gerar_oxigenio/1, gerar_hidrogenio/1, gerador/1]).

start() -> 
  gerador(3000),
  correioStart().

% Gerador de moleculas %
gerador(Intervalo) ->
  io:format("GERADOR - Iniciado ~n", []),
  timer:sleep(Intervalo),
  spawn(start, gerar_oxigenio, [self()]),
  timer:sleep(Intervalo),
  spawn(start, gerar_hidrogenio, [self()]),
  gerador(Intervalo).

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

correioStart() ->
  receive 
		{oxigenio, PidOx} -> 
      %io:format("CORREIO - oxigenio pronto com pid: ~w ~n", [PidOx]),
      correioLigacoes({oxigenio, PidOx}, nada, nada);
		{hidrogenio, PidHi} -> 
      %io:format("CORREIO - hidrogenio pronto com pid: ~w ~n", [PidHi]),
      correioLigacoes({hidrogenio, PidHi}, nada, nada)
	end.




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

correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, nada) ->
  receive 
		{oxigenio, PidOx} -> 
      correioLigacoes({hidrogenio, PidHiParam1}, {hidrogenio, PidHiParam2}, {oxigenio, PidOx})
		% {hidrogenio, PidHi} -> 
    %   correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi} , {oxigenio, PidOxParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({hidrogenio, PidHiParam}, nada , {oxigenio, PidOxParam}) -> % HO_
  receive 
		% {oxigenio, PidOx} -> 
    %   correioLigacoes({oxigenio, PidOx});
		{hidrogenio, PidHi} -> 
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi} , {oxigenio, PidOxParam})
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({hidrogenio, PidHiParam}, nada, nada) -> % H__
  receive 
		{oxigenio, PidOx} -> 
      correioLigacoes({hidrogenio, PidHiParam}, nada, {oxigenio, PidOx});
		{hidrogenio, PidHi} -> 
      correioLigacoes({hidrogenio, PidHiParam}, {hidrogenio, PidHi}, nada)
	end;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

correioLigacoes({oxigenio, PidOXParam}, nada, nada) -> % O__
  receive 
		% {oxigenio, PidOx} -> 
    %   correioLigacoes({oxigenio, PidOx}, {PidParamOX});
		{hidrogenio, PidHi} -> 
      correioLigacoes({hidrogenio, PidHi}, nada ,{oxigenio, PidOXParam})
	end.