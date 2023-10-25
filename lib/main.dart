import 'dart:convert';

import 'package:buscacep/http.services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busca CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Busca cep'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cepController = TextEditingController();

  final TextEditingController _endereco = TextEditingController();
  final TextEditingController _cidade = TextEditingController();
  final TextEditingController _bairro = TextEditingController();
  final TextEditingController _ibge = TextEditingController();
  final TextEditingController _uf = TextEditingController();

  final String _uri = 'viacep.com.br';

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  _retornoCep(int cep) async {
    HttpServices httpRun = HttpServices(
      baseUrl: _uri,
      endpoint: '/ws/$cep/json/',
    );
    logger.i(await HttpServices.getUri(_uri, '$cep/json/', null));

    http.Response httpResponse = await httpRun.getRequest();

    if (httpResponse.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(httpResponse.body);
      logger.i(jsonResponse);

      setState(() {
        _endereco.text = jsonResponse['logradouro'];
        _bairro.text = jsonResponse['bairro'];
        _cidade.text = jsonResponse['localidade'];
        _uf.text = jsonResponse['uf'];
        _ibge.text = jsonResponse['ibge'];
      });
    }
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    decoration: const InputDecoration(
                      labelText: 'Digite o CEP',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O CEP não pode estar vazio!';
                      }
                      if (!isNumeric(value)) {
                        return 'O CEP deve conter apenas números, sem traço e sem espaço!';
                      }
                      if (value.length != 8) {
                        return 'O CEP deve conter 8 números, sem traço e sem espaço!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, top: 0, left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _retornoCep(int.parse(_cepController.text.trim()));
                          },
                          child: const Text(
                            'Buscar',
                            style: TextStyle(
                              fontSize: 30,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _endereco,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _bairro,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _cidade,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _uf,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'UF',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _ibge,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Código IBGE',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
