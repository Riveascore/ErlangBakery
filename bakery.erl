-module(bakery).
-export([manager/2, serve/3, create_and_run_manager/2]).
-import(fib, [fibo/1]).

create_and_run_manager(NumberOfServers, NumberOfCustomers) ->
    Servers = lists:seq(1,NumberOfServers),
    Customers = lists:seq(NumberOfServers+1, NumberOfServers+NumberOfCustomers),
    manager(Servers, Customers).

manager(ServerList, []) ->
    io:format("No more customers program is done!"),
    true;
manager([], CustomerList) ->
    receive
	{Server} ->
	    NewServerList = [Server],
	    manager(NewServerList, CustomerList)
    end;
manager(ServerList, CustomerList) ->
    [Server|NewServerList] = ServerList,
    [Customer|NewCustomerList] = CustomerList,
    io:fwrite("Customer ~w is being served by server ~w!~n", [Customer, Server]),
    spawn(bakery, serve, [Server, Customer, self()]),
    receive
	{FreeServer} ->
	    NewerServerList = lists:append(NewServerList, [FreeServer]),
	    NewerServerList = NewServerList ++ [FreeServer],
	    manager(NewerServerList, NewCustomerList)
    after 0 ->
	    manager(NewServerList, NewCustomerList)	    
    end.
	    %later on make this^ a queue

serve(Server, Customer, ManagerPid) ->
    
    %% random:uniform(20)
    %% Input = random:uniform(20),
    Input = 30,
    Result = fib:fibo(Input),
    io:fwrite("Customer ~w was given ~w brownies!~n", [Customer, Result]),
    ManagerPid ! {Server}.
