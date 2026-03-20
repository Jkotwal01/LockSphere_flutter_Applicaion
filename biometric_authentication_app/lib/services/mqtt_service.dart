import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../core/constants.dart';

class MqttService {
  MqttServerClient? _client;
  final String _broker = AppConstants.mqttBrokerUrl;
  final String _clientId = 'sentinel_app_${DateTime.now().millisecondsSinceEpoch}';
  
  Function(bool isLocked)? onStateChange;
  Function(bool isConnected)? onConnectionChange;

  Future<bool> connect(String deviceId) async {
    _client = MqttServerClient(_broker, _clientId);
    
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 60;
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;
    _client!.onSubscribed = _onSubscribed;

    // Use WebSockets if standard port fails, but for now typical TCP:
    _client!.port = AppConstants.mqttPort;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    
    _client!.connectionMessage = connMess;

    try {
      if (kDebugMode) print('MQTT: Connecting to $_broker');
      await _client!.connect();
    } catch (e) {
      if (kDebugMode) print('MQTT Execption: $e');
      _client!.disconnect();
      return false;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      if (kDebugMode) print('MQTT: Connected');
      onConnectionChange?.call(true);
      
      // Subscribe to status topic
      final statusTopic = AppConstants.mqttTopicStatus.replaceAll('{deviceId}', deviceId);
      _client!.subscribe(statusTopic, MqttQos.atLeastOnce);
      
      // Listen for updates
      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        
        if (kDebugMode) print('MQTT: Received message on topic: <${c[0].topic}> payload: <-- $payload -->');
        
        try {
          // Expecting {"status": "LOCKED"} or {"status": "UNLOCKED"}
          final data = jsonDecode(payload);
          if (data['status'] == 'LOCKED') {
            onStateChange?.call(true);
          } else if (data['status'] == 'UNLOCKED') {
            onStateChange?.call(false);
          }
        } catch (e) {
          if (kDebugMode) print('MQTT Decode Error: $e');
        }
      });
      return true;
    } else {
      _client!.disconnect();
      return false;
    }
  }

  void _onDisconnected() {
    if (kDebugMode) print('MQTT: Disconnected');
    onConnectionChange?.call(false);
  }

  void _onConnected() {
    if (kDebugMode) print('MQTT: OnConnected Callback');
  }

  void _onSubscribed(String topic) {
    if (kDebugMode) print('MQTT: Subscribed to $topic');
  }

  bool sendAction(String deviceId, String action, String jwtToken) {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }
    
    final commandTopic = AppConstants.mqttTopicCommand.replaceAll('{deviceId}', deviceId);
    final builder = MqttClientPayloadBuilder();
    
    final payload = jsonEncode({
      "action": action, // "LOCKED" or "UNLOCKED"
      "token": jwtToken,
    });
    
    builder.addString(payload);
    
    _client!.publishMessage(commandTopic, MqttQos.atLeastOnce, builder.payload!);
    return true;
  }

  void disconnect() {
    _client?.disconnect();
  }
}
