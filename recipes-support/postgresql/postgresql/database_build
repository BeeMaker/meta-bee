#!/bin/sh

function stringToDatabase () {
	psql -U postgres -d beecoin -c "$1"
}

psql -U postgres -c "DROP DATABASE IF EXISTS BeeCoin"
psql -U postgres -c "CREATE DATABASE BeeCoin"

stringToDatabase "CREATE TABLE CoinID (
					id SERIAL PRIMARY KEY,
					marketName text,
					strategy_rsiBuy float8,
					strategy_rsiSell float8,
					strategy_macdIsPositif bool,
					strategy_macdGap float8);"

stringToDatabase "CREATE TABLE CoinMarket (
					idCoin bigint,
					dateTime timestamp,
					currency float8);"

stringToDatabase "CREATE TABLE OrderBook (
					idCoin bigint,
					dateTime timestamp,
					currency float8
					);"


request="/usr/bin/curl https://bittrex.com/api/v1.1/public/getmarketsummary?market=usdt-btc"


echo $request

result=`eval $request > /tmp/jsonFile.json `
marketName=`cat /tmp/jsonFile.json | jq -r '.result[0] .MarketName'`


stringToDatabase "INSERT INTO coinid (\"marketname\", \"strategy_rsibuy\", \"strategy_rsisell\", \"strategy_macdispositif\", \"strategy_macdgap\")
                  VALUES ('$marketName', 55, 45, true, 1);"

                  stringToDatabase "Select * from coinid;"
