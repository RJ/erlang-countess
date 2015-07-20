-module(countserv).
-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {counter, interval, step}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
        gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    State = #state{
        counter = 0,
        interval = 1000,
        step = 1
    },
    erlang:send_after(State#state.interval, self(), tick),
    {ok, State}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(tick, State = #state{counter=C, interval=I, step=S}) ->
    NewCounter = C + S,
    NewState = State#state{counter = NewCounter},
    io:format("Counter is: ~B\n", [NewCounter]),
    erlang:send_after(I, self(), tick),
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


