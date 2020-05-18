import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: Converter()));
}

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  final fromTextController = TextEditingController();
  List<String> currencies;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  String results;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String url = 'https://api.exchangeratesapi.io/latest?base=INR';
    var response = await http.get(Uri.encodeFull(url));
    var responseBody = jsonDecode(response.body); //response body is a map
    //rates is a key in response body which is itself a map
    Map curMap = responseBody['rates']; // map is exactly like a dictionary
    currencies = curMap.keys.toList(); //currencies is a list which has all the map's keys as its elements :)
    setState(() {

    });
    print(currencies);
    return ("Syccess");
  }


  Future<String> _doConversion() async{
    String uri = 'https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency';
    var response = await http.get(Uri.encodeFull(uri));
    var responseBody = jsonDecode(response.body); //response body is a map
    setState(() {
      results = (double.parse(fromTextController.text) * (responseBody['rates'][toCurrency])).toString(); //making the input which was given in fromcontroller text to double and multiplying it by rate
    });
    print(results);
    return "Success!";
  }



  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value; //update value of fromcurrency and update the value of drop down button
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value; //update value of TO_currency and update the value of drop down button
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text('Currency Converter'),
        centerTitle: true,
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          _doConversion();
                        },
                      ),
                      ListTile(
                        title: Chip(
                          backgroundColor: Colors.white70,
                          label: results != null ?
                          Text(
                            results,
                            style: Theme.of(context).textTheme.headline4,
                          )
                              :Text(""),
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                    ],
                  ),
                ),
              ),
            ),

    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies.map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if(currencyCategory == fromCurrency) {
          _onFromChanged(value);
        }
        else {
          _onToChanged(value);
        }
      },
    );
  }
}
