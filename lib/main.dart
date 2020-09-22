import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _gasolinaController = TextEditingController();
  TextEditingController _etanolController = TextEditingController();
  TextEditingController _gnvController = TextEditingController();
  String _resultado;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _gasolinaController.text = "";
    _etanolController.text = "";
    _gnvController.text = "";
    setState(() {
      _resultado = "Informe seus dados";
    });
  }

  void calculaCombustivel() {
    double gasolina = double.parse(_gasolinaController.text);
    double etanol = double.parse(_etanolController.text);
    double gnv = double.parse(_gnvController.text);
    double resultado = etanol / gasolina;
    setState(() {
      _resultado = "O melhor é ";
      if (resultado < 0.7) {
        if (etanol / gnv < 2) {
          _resultado += "Etanol";
        } else {
          _resultado += "GNV";
        }
      } else if (resultado > 0.7) {
        if (gasolina / gnv < 0.71) {
          _resultado += "Gasolina";
        } else {
          _resultado += "GNV";
        }
      } else if (resultado == 0.7) {
        if (etanol / gnv == 0.5) {
          _resultado = "Tanto faz !!!";
        } else {
          _resultado += "GNV";
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApp(),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20), child: buildForm()),
    );
  }

  AppBar buildApp() {
    return AppBar(
        title: Text("Ecobustil"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                resetFields();
              })
        ]);
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: " Gasilina ",
              error: "Valor da gasolina",
              control: _gasolinaController),
          Divider(),
          buildTextFormField(
              label: " Etanol ",
              error: "Valor do etanol",
              control: _etanolController),
          Divider(),
          buildTextFormField(
              label: " GNV ", error: "Valor do GNV", control: _gnvController),
          buildTextResult(),
          buildCalculateButton()
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
        padding: EdgeInsets.all(36),
        child: RaisedButton(
          child: Text("Calcular"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              calculaCombustivel();
            }
          },
        ));
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _resultado,
        textAlign: TextAlign.center,
      ),
    );
  }

  TextFormField buildTextFormField(
      {TextEditingController control, String error, String label}) {
    return TextFormField(
      controller: control,
      keyboardType: new TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: label,
          hintText: " 0,00",
          prefixText: "R\$",
          border: OutlineInputBorder()),
    );
  }
}
