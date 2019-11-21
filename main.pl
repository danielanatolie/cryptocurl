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
    write("Your budget is: "),
    write(StartingCapital),
    nl,
    write("We recommend diversiving into the top 3 coins: BTC, ETH, and XRP"),
    nl,
    print_current_prices(),
    nl.

print_current_prices() :-
    get_current_prices(BTCPrice, ETHPrice, XRPPrice),
    write("The current price of: "),
    nl,
    write("Bitcoin (BTC) is: "),
    write(BTCPrice),
    nl,
    write("Ethereum (ETH) is: "),
    write(ETHPrice),
    nl,
    write("XRP is: "),
    write(XRPPrice).


get_current_prices(BTCPrice, ETHPrice, XRPPrice) :-
    get_current_price_from_api(Data),
    BTCPriceObj = Data.get(bitcoin),
    ETHPriceObj = Data.get(ethereum),
    XRPRiceObj = Data.get(ripple),
    BTCPrice = BTCPriceObj.get(usd),
    ETHPrice = ETHPriceObj.get(usd),
    XRPPrice = XRPRiceObj.get(usd).

get_current_price_from_api(Data) :-
    URL = "https://api.coingecko.com/api/v3/simple/price?ids=ethereum,ripple,bitcoin&vs_currencies=usd",
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Data),
        close(In)).

% Cryptocurrency Historical Data following:
% currencyName(allTimeHigh)
bitcoin(19665).
