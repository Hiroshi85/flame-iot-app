// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// 192.168.18.17

class MqttEmqxClient {
  final _client =
      MqttServerClient.withPort('ws://emqx@192.168.18.17/mqtt', 'mobile', 8083);

  MqttEmqxClient() {
    _client.logging(on: true);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = pong;
    _client.useWebSocket = true;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .startClean() // Non persistent session for testing
        .authenticateAs(null, 'mobile')
        .withWillQos(MqttQos.exactlyOnce);
    _client.connectionMessage = connMess;
  }

  Future<MqttServerClient?> get client async {
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      _client.disconnect();
      return null;
    } on SocketException catch (e) {
      print('socket exception - $e');
      _client.disconnect();
      return null;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('client connected');
      const topic = 'datos-view';
      _client.subscribe(topic, MqttQos.atMostOnce);
      print('Subscribing to the $topic topic');

      return _client;
    } else {
      print(
          'client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
      return null;
    }
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> getDataStream() {
    return _client.updates!;
  }

  Map<String, dynamic> getFormattedDataReceived(
      List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    String jsonString =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('Received message: topic is ${c[0].topic}, payload is $jsonString');

    jsonString = jsonString.replaceAll('\n', '').replaceAll('\r', '');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    String payload = jsonMap['payload'];
    Map<String, dynamic> payloadContent = json.decode(payload)['content'];

    jsonMap['payload'] = payloadContent;
    return jsonMap;
  }

  Future<int> main() async {
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      print('socket exception - $e');
      _client.disconnect();
    }

    // _client.updates!.listen(formattedDataReceived);

    return 0;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
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
}
