import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tire_data_model.dart';
import 'package:intl/intl.dart';

typedef UpdateMarkerCallback = void Function(
    LatLng location, Map<String, dynamic> tireData, String time);

class MqttService {
  late MqttServerClient _mqttClient;
  final String _mqttBroker = 'test.mosquitto.org';
  final String _mqttTopic = 'location_topic';
  List<Map<String, dynamic>> tireDataList = [];
  ValueNotifier<Map<String, dynamic>> tireDataNotifier = ValueNotifier({});
  Map<String, dynamic> tireData = {};

  void connect(
    BuildContext context, 
    TireDataModel tireDataModel,
    UpdateMarkerCallback? updateMarkerCallback
  ) async {
    _mqttClient = MqttServerClient(_mqttBroker, 'flutter_client');
    _mqttClient.logging(on: true);

    try {
      await _mqttClient.connect();
      print('Connected to MQTT broker');

      _mqttClient.subscribe(_mqttTopic, MqttQos.atLeastOnce);
      _mqttClient.updates!.listen(
        (List<MqttReceivedMessage<MqttMessage>> messages) {
          _onMessageReceived(messages, context, tireDataModel, updateMarkerCallback);
        },
      );
    } catch (e) {
      print('Failed to connect to MQTT broker: $e');
    }
  }

void _onMessageReceived(
  List<MqttReceivedMessage<MqttMessage>> messages,
  BuildContext context,
  TireDataModel tireDataModel,
  UpdateMarkerCallback? updateMarkerCallback,
) {
  for (final MqttReceivedMessage<MqttMessage> message in messages) {
    final MqttPublishMessage payloadMessage = message.payload as MqttPublishMessage;
    final String payload = MqttPublishPayload.bytesToStringAsString(payloadMessage.payload.message);

    final List<dynamic> jsonPayloadList = jsonDecode(payload);
    for (final dynamic jsonPayload in jsonPayloadList) {
      final double latitude = jsonPayload['latitude']?.toDouble() ?? 0.0;
      final double longitude = jsonPayload['longitude']?.toDouble() ?? 0.0;

      final Map<String, dynamic> tireData = jsonPayload['ban'] ?? {};

      print('Menerima pembaruan lokasi: Latitude: $latitude, Longitude: $longitude');
      final DateTime now = DateTime.now();
      final String formattedTime = DateFormat('HH:mm:ss dd/MM/yyyy').format(now);

      if (latitude != 0.0 && longitude != 0.0) {
        final LatLng receivedLocation = LatLng(latitude, longitude);
        updateMarkerCallback?.call(receivedLocation, tireData, formattedTime);
      }

      tireDataModel.updateTireData(
        frontRightPressure: tireData['frontRight']['pressure']?.toDouble(),
        frontRightTemp: tireData['frontRight']['temp']?.toDouble(),
        frontLeftPressure: tireData['frontLeft']['pressure']?.toDouble(),
        frontLeftTemp: tireData['frontLeft']['temp']?.toDouble(),
        backLeftPressure: tireData['backLeft']['pressure']?.toDouble(),
        backLeftTemp: tireData['backLeft']['temp']?.toDouble(),
        backRightPressure: tireData['backRight']['pressure']?.toDouble(),
        backRightTemp: tireData['backRight']['temp']?.toDouble(),
      );
    }
  }
}

  void disconnect() {
    _mqttClient.disconnect();
  }
}
