import 'package:flame_iot_app/Components/arduino_card.dart';
import 'package:flame_iot_app/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bosque Cachil - Monitoreo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitoreo Bosque Cachil'),
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
  late Future<MqttServerClient?> mqttConnection;
  late MqttEmqxClient mqttEmqxClient;
  @override
  void initState() {
    super.initState();
    mqttEmqxClient = MqttEmqxClient();
    mqttConnection = mqttEmqxClient.client;
  }

  List<ArduinoCard> arduinos() {
    return [
      ArduinoCard(
        mqttEmqxClient: mqttEmqxClient,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<MqttServerClient?>(
          future: mqttConnection,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                scrollDirection: Axis.vertical,
                children: arduinos(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
