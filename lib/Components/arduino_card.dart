import 'package:flame_iot_app/Components/topic_tile.dart';
import 'package:flame_iot_app/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ArduinoCard extends StatefulWidget {
  final MqttEmqxClient mqttEmqxClient;
  const ArduinoCard({super.key, required this.mqttEmqxClient});

  @override
  State<ArduinoCard> createState() => _ArduinoCardState();
}

class _ArduinoCardState extends State<ArduinoCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
        stream: widget.mqttEmqxClient.getDataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> datos = widget.mqttEmqxClient
                .getFormattedDataReceived(snapshot.data)['payload'];
            return SizedBox(
              height: 230,
              child: Card(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Arduino ${datos['id']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 140,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                children: [
                                  TopicTile(
                                    tema: "Carbono",
                                    color:
                                        const Color.fromARGB(255, 125, 72, 51),
                                    valor: '${datos['gas']}',
                                    topicIcon: Icons.gas_meter,
                                  ),
                                  TopicTile(
                                    tema: "Temp",
                                    color: Colors.green,
                                    valor: '${datos['temp']}°C',
                                    topicIcon: Icons.thermostat_rounded,
                                  ),
                                  TopicTile(
                                    tema: "Humedad",
                                    color: Colors.indigo,
                                    valor: '${datos['hum']}%',
                                    topicIcon: Icons.water,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            TopicTile(
                                tema: "Fuego",
                                color: datos['flame']
                                    ? Colors.red
                                    : const Color.fromARGB(255, 155, 155, 155),
                                valor: datos['flame'] ? "SÍ" : "NO",
                                topicIcon: Icons.local_fire_department_rounded)
                          ],
                        ),
                      ),
                      Text(
                        'Recibido a: ${DateTime.now().toString().substring(0, 19)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: LinearProgressIndicator(),
          );
        });
  }
}
