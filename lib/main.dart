//Código que ya se actualiza. :)
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); //IDK, quitar si se puede

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "First App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 5, 29, 90)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String receivedData = '';
  Socket? socket;
  Socket? socket2;
  String? string_time;
  String? string_desp;
  List<dynamic> time = [];
  List<dynamic> disp = [0];

  //Socket? socket3;
  String decodedData = "";
  String str_list = '';
  List<dynamic> list = []; //List<List<int>>
  var paquete = 0;

  List<dynamic> decodeList(String str) {
    return jsonDecode(str);
  }

  void save_time(dynamic data) {
    //print(data.length);

    time = decodeList(data);
    //notifyListeners();
  }

  void save_disp(dynamic data) {
    disp = decodeList(data);
    //print(data.length);
    print("Disp length----");
    print(disp.length);
    print("Time length----");
    print(time.length);
    notifyListeners();
  }

  void _startSocketCommunication() async {
    //while(true){
    // Connect to MicroPython Access Point
    socket = await Socket.connect('192.168.4.1', 80);
    socket!.add(utf8.encode("---------Flag------------"));
    socket!.close();
    await Future.delayed(const Duration(milliseconds: 100));
    Socket socket3 = await Socket.connect('192.168.4.1', 8080);
    List<int> receivedData_time = [];

    socket3.listen(
      //TIME DATA
      (List<int> data) {
        receivedData_time.addAll(data);
      },onError: (error) {
          print('Error receiving data: $error');
        },
        onDone: () {
          // Data reception is complete
          decodedData = String.fromCharCodes(receivedData_time);
          //print('Received data: $decodedData');
          print(decodedData.length);
          save_time(decodedData);
          // Close the socket
          socket3.close();
        },
    );

    print("---------------");

    print("............0");

    await Future.delayed(const Duration(milliseconds: 100));
    Socket socket2 = await Socket.connect('192.168.4.1', 81);
    List<int> receivedData_desp = [];

    socket2.listen( //DISP DATA
      (List<int> data) {
        receivedData_desp.addAll(data);
      },
      onError: (error) {
        print('Error receiving data: $error');
      },
      onDone: () {
        // Data reception is complete
        decodedData = String.fromCharCodes(receivedData_desp);
        //print('Received data: $decodedData');
        print(decodedData.length);
        // Close the socket
        save_disp(decodedData);
        //disp = decodeList(decodedData);
        socket2.close();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Random random = Random();
  List<List<int>> stringToList(String str) {
    List<List<int>> result = [];
    
    // Divide la cadena en partes usando "],[" como delimitador
    List<String> parts = str.split("],[");
    // Itera sobre cada parte y convierte las subcadenas en listas de enteros
    for (String part in parts) {
      List<int> innerList = [];
      // Elimina los corchetes iniciales y finales
      part = part.replaceAll('[', '').replaceAll(']', '');
      List<String> innerParts = part.split(',');
      for (String innerPart in innerParts) {
        innerList.add(int.parse(innerPart.trim()));
      }
      result.add(innerList);
    } 
    return result;
  }

  
  List<FlSpot> generateRandomData(double count) {
    List<FlSpot> data = [];
    for (int i = 0; i < 100; i++) {
      data.add(FlSpot(i.toDouble(), count)); // Random value between 0 and 100
    }
    return data;
  }

  List<FlSpot> createdata(List data) {
    List<FlSpot> result = [];
    for (int i = 0; i < data.length; i++) {
      result.add(FlSpot(
          i.toDouble(), data[i].toDouble())); // Random value between 0 and 100
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<dynamic> disp = appState.disp;
    //List<FlSpot> displacement = [];
    // List<dynamic> originalList = [1, 2, 3, 4, 5]; // Example list
    List<FlSpot> displacement = <FlSpot>[];
    displacement = createdata(disp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500, // Fixed width
              height: 300, // Fixed height
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: displacement,
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 1,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  minY: 0,
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(showTitles: false),
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 500),
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                appState._startSocketCommunication();
                //updateGraphData();
              },
              child: const Text('Update Data'),
            ),
          ],
        ),
      ),
    );
  }
}
