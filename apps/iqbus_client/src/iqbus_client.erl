-module(iqbus_client).

-export([start_link/0]).

start_link() ->
    try start_link1() of
        _ -> ok
    catch
        _ -> io:format("Stacktrace: ~p~n", [erlang:get_stacktrace()])
    end.

 start_link1() ->
    {ok, Conf} = application:get_env(iqbus_client, connection),
    [{host, Host}, {port, Port}] = Conf, 
    connect(Host, Port).
connect(Host, Port) ->
    {ok, Socket} = gen_tcp:connect(Host, Port, [binary, {active, false}]),
    io:format("client opened socket=~p~n", [Socket]),
    spawn(fun() -> recv(Socket) end),
    Socket.

recv(Socket) ->
    {ok, Raw} = gen_tcp:recv(Socket, 0),
    io:format("Received: ~p~n", [Raw]),
    % case Raw of
    %     {}
    recv(Socket).

disconnect(Socket) ->
    gen_tcp:close(Socket).
