import 'package:flame_iot_app/Components/topic_tile.dart';
import 'package:flame_iot_app/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart';

class ArduinoCard extends StatefulWidget {
  final MqttEmqxClient mqttEmqxClient;
  const ArduinoCard({super.key, required this.mqttEmqxClient});

  @override
  State<ArduinoCard> createState() => _ArduinoCardState();
}

class _ArduinoCardState extends State<ArduinoCard> {
  late Location location;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location = tz.getLocation('America/Lima');
  }

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
                            const SizedBox(width: 10),
                            TopicTile(
                              tema: "Fuego",
                              color: datos['flame']
                                  ? Colors.red
                                  : datos['flame_p']
                                      ? const Color.fromARGB(255, 255, 140, 0)
                                      : const Color.fromARGB(
                                          255, 155, 155, 155),
                              valor: datos['flame']
                                  ? "SÍ"
                                  : datos['flame_p']
                                      ? "POSIBLE"
                                      : "NO",
                              topicIcon: Icons.local_fire_department_rounded,
                              isWarning: datos['flame']
                                  ? datos['flame']
                                  : datos['flame_p'],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Recibido a: ${tz.TZDateTime.from(DateTime.now(), location)}',
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
