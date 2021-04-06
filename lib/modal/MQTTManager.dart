import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:ee_fyp/providers/MQTTState.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ee_fyp/providers/payload_provider.dart';

class MQTTManager {
  final Payloads _payloads;
  final MQTTState _currentState;
  MqttServerClient _client;
  final String _identifier;
  final String _host;
  final String _topic;
  final bool _isUUID;

  MQTTManager(
      {@required String host,
      @required String topic,
      @required String identifier,
      @required MQTTState state,
      @required bool isUUID,
      Payloads payloads})
      : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state,
        _payloads = payloads,
        _isUUID = isUUID;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: true);

    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  void connect() async {
    assert(_client != null);
    try {
      print('Mosquitto start client connecting....');
      _currentState.setConnectionState(MQTTConnectionState.connecting);
      await _client.connect();
    } on Exception catch (e) {
      print('Client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setConnectionState(MQTTConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setConnectionState(MQTTConnectionState.connected);
    print('Mosquitto client connected....');
    if (_isUUID) {
      _client.subscribe('getUUID', MqttQos.atLeastOnce);
      print('Subscribed to second topic: getUUID');
    } else {
      _client.subscribe(_topic, MqttQos.atLeastOnce);
      print('Subscribed to topic ' + _topic);
    }
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(pt);

      if (_isUUID && pt != "1") {
        String cleanString = pt.replaceAll('"', '');
        _payloads.getUUID(cleanString);
        print('Getting uuid from mqtt message. UUID = $pt');
      }
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print('OnConnected client callback - Client connection was sucessful');
  }
}
