import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=b488630c';

void main() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body)['results']['currencies']['USD']);

  runApp(MaterialApp(
      home: Home(),
      
      ));
}

//obtendo json
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
            '\$ Conversor \$',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0, 126, 66, 1)),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                      fontSize: 25, color: Color.fromRGBO(0, 126, 66, 1)),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao carregar dados...",
                  style: TextStyle(
                      fontSize: 25, color: Color.fromRGBO(0, 126, 66, 1)),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Color.fromRGBO(0, 126, 66, 1)),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25),
                        decoration: InputDecoration(
                            labelText: 'Real',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(0, 126, 66, 1),
                                fontSize: 25),
                            border: OutlineInputBorder(),

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 126, 66, 1))),
                            prefixText: 'R\$ ',
                            prefixStyle: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25)
                            ),
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25),
                        decoration: InputDecoration(
                            labelText: 'Dolar',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(0, 126, 66, 1),
                                fontSize: 25),
                            border: OutlineInputBorder(),

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 126, 66, 1))),
                            prefixText: 'USS ',
                            prefixStyle: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25)
                            ),
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25),
                        decoration: InputDecoration(
                            labelText: 'Euro',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(0, 126, 66, 1),
                                fontSize: 25),
                            border: OutlineInputBorder(),

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 126, 66, 1))),
                            prefixText: 'EUR ',
                            prefixStyle: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25)
                            ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
