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

  final _realController = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController = TextEditingController();

  void _clearAll(){
    _realController.text = "";
    _dolarController.text = "";
    _euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    _dolarController.text = (real/dolar).toStringAsFixed(2);
    _euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    _realController.text = (dolar*this.dolar).toStringAsFixed(2);
    _euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    _realController.text = (euro  * this.euro).toStringAsFixed(2);
    _dolarController.text = (euro * this.euro  / dolar).toStringAsFixed(2);
  }

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

                      inputText('Real', 'R\$ ', _realController, _realChanged),
                      Divider(),
                      inputText('Dolar', 'USS ', _dolarController, _dolarChanged),
                      Divider(),
                      inputText('Euro', 'EUR ', _euroController, _euroChanged)
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

Widget inputText(String label, String prefix, TextEditingController controller, Function changed) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    style: TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25),
    decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 20),
        border: OutlineInputBorder(),

        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(0, 126, 66, 1))
        ),
        //colocar essa pra borda mudar cor na seleção

        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(0, 126, 66, 1))
        ),
        //colocar essa pra borda ficar OURO antes da seleção
        
        prefixText: prefix,
        prefixStyle:
            TextStyle(color: Color.fromRGBO(0, 126, 66, 1), fontSize: 25)),
        onChanged: changed,
  );
}