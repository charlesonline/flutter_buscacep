import 'dart:convert';
// import 'dart:io';

import 'package:buscacep/http.services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  final String _uri = 'viacep.com.br';

  String? cepret;
  String? endereco;
  String? cidade;
  String? bairro;
  String? ibge;
  String? uf;
  String? ddd;

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
        cepret = jsonResponse['cep'];
        endereco = jsonResponse['logradouro'];
        bairro = jsonResponse['bairro'];
        cidade = jsonResponse['localidade'];
        uf = jsonResponse['uf'];
        ibge = jsonResponse['ibge'];
        ddd = jsonResponse['ddd'];
      });
    }
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
                    decoration: const InputDecoration(
                      labelText: 'Digite o CEP',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O CEP deve conter 8 numeros, sem traço e sem espaço!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, top: 0, left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _retornoCep(int.parse(_cepController.text));
                          },
                          child: const Text(
                            'Salvar',
                            // style: TextStyle(
                            //   fontSize: 30,
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                ),
                const Text("Dados do endereço:"),
                const SizedBox(height: 20),
                Text("CEP: $cepret"),
                Text("Endereço: $endereco"),
                Text("Bairro: $bairro"),
                Text("Cidade: $cidade"),
                Text("UF: $uf"),
                Text("IBGE: $ibge"),
                Text("DDD: $ddd"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
