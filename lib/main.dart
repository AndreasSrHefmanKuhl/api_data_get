import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as chuck;

void main() {
  runApp(const MainApp());
}

//https://api.api-ninjas.com/v1/chucknorris
/*{
  "joke": "Chuck Norris makes onions cry."
}*/

Future<List<dynamic>> getChuck() async {
  final Uri uri = Uri.https(
    'https://api.api-ninjas.com',
    '/v1/chucknorris',
  );
  final chuck.Response response = await chuck.get(uri);

  if (response.statusCode == 200) {
    final String chuckData = response.body;
    final Map<String, dynamic> chuckJson = jsonDecode(chuckData);
    final chuckQuotes = chuckJson["joke"];
    return chuckQuotes;
  }
  return [];
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String finalChuck = 'yo';

  @override
  void initState() {
    super.initState;
    getChuck();
    getFirstChuck();
  }

  Future<String> getFirstChuck() async {
    final List<dynamic> chucks = await getChuck();
    final Map<String, dynamic> singleChuck = chucks[0];
    final firstChuck = singleChuck['joke'];

    setState(() {
      finalChuck = firstChuck;
    });
    return finalChuck;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder<String>(
              future: getFirstChuck(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final String finalChuck = snapshot.data!;

                  return Text(finalChuck);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return const CircularProgressIndicator(); //mit ladebildschirm rumgespielt
              },
            ),
            Text(finalChuck, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () => getFirstChuck(),
                child: const Icon(Icons.fast_rewind_rounded)),
          ]),
        ),
      ),
    );
  }
}
