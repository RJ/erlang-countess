%%%-------------------------------------------------------------------
%% @doc countess top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('countess_sup').

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

init([]) ->
    Children = [
        {countserv,
            {countserv, start_link, []},
            permanent, 5000, supervisor, [countserv]}
    ],
    {ok, {{one_for_one, 10, 1}, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
