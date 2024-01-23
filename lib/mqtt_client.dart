import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// 192.168.18.17
final client =
    MqttServerClient.withPort('ws://emqx@192.168.18.17/mqtt', 'mobile', 8083);

void prepareMqttConnection() {}

Future<bool> isMqttConnectionSuccessful() async {
  try {
    await client.connect();
    return true;
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
    return false;
  } on SocketException catch (e) {
    print('socket exception - $e');
    client.disconnect();
    return false;
  }
}

Future<int> main() async {
  client.logging(on: true);
  client.keepAlivePeriod = 60;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;
  client.useWebSocket = true;

  final MqttConnectMessage connMess = MqttConnectMessage()
      .startClean() // Non persistent session for testing
      .authenticateAs(null, 'mobile')
      .withWillQos(MqttQos.exactlyOnce);
  // print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('client connected');
  } else {
    print(
        'client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  const topic = 'datos-view';
  print('Subscribing to the $topic topic');
  client.subscribe(topic, MqttQos.atMostOnce);
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('Received message: topic is ${c[0].topic}, payload is $pt');
  });

  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  }
  exit(-1);
}

/// The successful connect callback
void onConnected() {
  print('OnConnected client callback - Client connection was sucessful');
}

/// Pong callback
void pong() {
  print('Ping response client callback invoked');
}
