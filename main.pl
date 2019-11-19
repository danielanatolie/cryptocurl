:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

start() :- 
    write("Please provide your risk tolerance: type 0 for low or 1 for high (Type in quotes)"),
    nl,
    read(Risk),
    (Risk =:= 1 ->
        write("You are ready to invest! Provide your budget: type 100, 1000, or 10000 USD"),
        nl,
        read(StartingCapital),
        invest(StartingCapital)
    ;   
        write("Sorry, we advice not to participate in crypto investing."),
        fail
    ).

invest(StartingCapital) :-
    write("We recommend diversiving into the top 3 coins: BTC, ETH, and XRP"),
    % TODO Get user time: 1, 5 or 10 years

    % Calculate profit based on time 
    % profit = finalValue - currentValue
    % where currentValue = 3rd Party API call to coinGecko  
    % where finalValue = the best combination of coins based on the future predicted value
    nl,
    ( StartingCapital =:= 10000 -> 
        write("Your budget is 10000 USD")
    ; StartingCapital =:= 1000 -> 
        write("Your budget is 1000 USD, we recommend diversiving into the top 3 coins: BTC, ETH, and XRP")
    ; StartingCapital =:= 100 ->
        write("Your budget is 100 USD, we recommend diversiving into the top 3 coins: BTC, ETH, and XRP")
    ).
