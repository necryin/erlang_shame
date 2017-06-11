%%%-------------------------------------------------------------------
%% @doc iqbus_client top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(iqbus_client_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    SupFlags = #{strategy => one_for_all, intensity => 10, period => 60},
    ChildSpecs = [#{id => iqbus_client_worker,
                    start => {iqbus_client, start_link, []},
                    restart => permanent,
                    shutdown => 5000,
                    type => worker,
                    modules => [iqbus_client]}],
    {ok, {SupFlags, ChildSpecs}}.

%%====================================================================
%% Internal functions
%%====================================================================
