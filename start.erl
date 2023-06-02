-module(start).
-export([start/1]).

start(Interval) -> 
  create_oxygen(Interval).

create_oxygen(Interval) ->
  Pid = spawn(fun(Interval) -> io:format("Fui criado oxygen. ~n", []), timer:sleep(Interval) end),
  io:format("Criado um processo de oxigênio. ~w ~n", [Pid]).
  % timer:sleep(Interval),
  % create_hydrogen(Interval).

% create_hydrogen(Interval) ->
%   Pid = spawn(fun() -> io:format("Fui criado hydrigen. ~n", []) end),
%   timer:sleep(Interval),
%   io:format("Criado um processo de hidrogenio.~w ~n", [Pid]),
%   create_oxygen(Interval).