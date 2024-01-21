import 'package:flame_iot_app/Components/topic_tile.dart';
import 'package:flutter/material.dart';

class ArduinoCard extends StatefulWidget {
  const ArduinoCard({super.key});

  @override
  State<ArduinoCard> createState() => _ArduinoCardState();
}

class _ArduinoCardState extends State<ArduinoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Card(
        margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Arduino 1",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 140,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          TopicTile(
                            tema: "Carbono",
                            color: Color.fromARGB(255, 125, 72, 51),
                            valor: "25%",
                            topicIcon: Icons.gas_meter,
                          ),
                          TopicTile(
                            tema: "Temp",
                            color: Colors.green,
                            valor: "25°C",
                            topicIcon: Icons.thermostat_rounded,
                          ),
                          TopicTile(
                            tema: "Humedad",
                            color: Colors.indigo,
                            valor: "50%",
                            topicIcon: Icons.water,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    TopicTile(
                        tema: "Fuego",
                        color: Colors.red,
                        valor: "SÍ",
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
}
