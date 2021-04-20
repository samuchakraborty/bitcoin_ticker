
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';



  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = (value);
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var items = Text(currency);
      pickerItems.add(items);
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidDropDown();
    }
  }

  //value
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data =
          await CoinData().getCoinInformation(currencyType: selectedCurrency);
      isWaiting = false;
      setState(() {
        print("////////hello");
        print(data);
        coinValues = data;

         print(coinValues);
      });
    } catch (e) {
      print("/////");
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Column makeCard() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(CryptoCard(
          value: isWaiting ? '? ' : coinValues[crypto],
          selectedCurrency: selectedCurrency,
          cryptoCurrency: crypto));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoCards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({this.selectedCurrency, this.value, this.cryptoCurrency});

  final String value, selectedCurrency, cryptoCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
