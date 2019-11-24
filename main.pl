:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- use_module(library(date)).

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
    print_current_prices(BTCPrice),
    (StartingCapital >= BTCPrice ->
            round(BTCPrice, BTCPriceRounded),
            write("You'll be able to purchase: "),
            BTCAmount is div(StartingCapital, BTCPriceRounded),
            write(BTCAmount),
            write(" BTC"),
            nl,
            computeScore(CoinScore),
            write("CoinScore is: "),
            write(CoinScore),
            % TODO: analyzePriceTrend(PriceTrend),
            nl
        ;
            write("Insufficient funds."),
            fail
        ).    

print_current_prices(BTCPrice) :-
    get_current_prices(BTCPrice),
    write("The current price of: "),
    nl,
    write("Bitcoin (BTC) is: "),
    write(BTCPrice),
    nl.

% ~~~~~~~~~~~~~~~
% Get BTC prices
% ~~~~~~~~~~~~~~~
get_current_prices(BTCPrice) :-
    get_current_price_from_api(Data),
    BTCPriceObj = Data.get(bitcoin),
    BTCPrice = BTCPriceObj.get(usd).

get_current_price_from_api(Data) :-
    URL = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd",
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Data),
        close(In)).

get_historical_prices(YesterdayPrice, LastMonthPrice, LastYearPrice) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    (Day =:= 1 ->
        Yesterday is 25
    ;
        Yesterday is Day-1
    ),
    (Month =:= 1 ->
        LastMonth is  12
    ;
        LastMonth is Month-1
    ),
    LastYear is Year-1,
    get_coin_price_from_api(YesterdayData, "bitcoin", Yesterday, Month, Year),
    YesterdayMarketDataObj = YesterdayData.get(market_data),
    YesterdayPriceObj = YesterdayMarketDataObj.get(current_price),
    YesterdayPrice = YesterdayPriceObj.get(usd),
    write(YesterdayPrice).


get_coin_price_from_api(Data, CoinName, Day, Month, Year) :-
    URLv1 = "https://api.coingecko.com/api/v3/coins/",
    string_concat(URLv1, CoinName, URLv2),
    string_concat(URLv2, "/history?date=", URLv3),
    string_concat(URLv3, Day, URLv4),
    string_concat(URLv4, "-", URLv5),
    string_concat(URLv5, Month, URLv6),
    string_concat(URLv6, "-", URLv7),
    string_concat(URLv7, Year, URL),
    nl,
    write(URL),
    nl,
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Data),
        close(In)).


% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% Finds overall coin score
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
computeScore(CoinScoreRounded) :-
    get_coin_data_from_api(Data),
    DeveloperScore = Data.get(developer_score),
    CommunityScore = Data.get(community_score),
    round(DeveloperScore, DeveloperScoreRounded),
    round(CommunityScore, CommunityScoreRounded),
    avg([DeveloperScoreRounded, CommunityScoreRounded], CoinScore),
    round(CoinScore, CoinScoreRounded).

get_coin_data_from_api(Data) :-
    URL = "https://api.coingecko.com/api/v3/coins/bitcoin",
    setup_call_cleanup(
        http_open(URL, In, []),
        json_read_dict(In, Data),
        close(In)).

avg(List, Average):- 
    sum_list(List, Sum),
    length(List, Length),
    Length > 0, 
    Average is Sum / Length.

% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% Finds overall price trend
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
