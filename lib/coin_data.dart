import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  var apikey = "FECD2B04-09D9-4F3B-8B74-7F31E0816F0F";

  Future getCoinInformation({currencyType}) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      http.Response response = await http.get(Uri.parse(
          "https://rest.coinapi.io/v1/exchangerate/$crypto/$currencyType?apikey=$apikey"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var usdValue = data['rate'].toInt().toString();
        cryptoPrices[crypto] = usdValue;
        print(cryptoPrices);
       // return usdValue;
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
    //  print(usdValue);
  }
}
