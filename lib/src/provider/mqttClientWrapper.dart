import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:flutter/material.dart';
//import 'package:SDRV2_APP/converter.dart';
import 'package:SDRV2_APP/constants.dart' as Constants;

import 'package:mqtt_client/mqtt_client.dart';

import 'package:SDRV2_APP/src/models/mqtt_models.dart';

class MQTTClientWrapper {

  MqttClient client;
  // LocationToJsonConverter locationToJsonConverter = LocationToJsonConverter();
  // JsonToLocationConverter jsonToLocationConverter = JsonToLocationConverter();

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  final VoidCallback onConnectedCallback;
  final Function(MqttProtocol data,String topic) onDeviceDataReceivedCallback;

  MQTTClientWrapper(this.onConnectedCallback, this.onDeviceDataReceivedCallback);
  final _mqttStreamController = StreamController<MqttProtocol>.broadcast();
  Function(MqttProtocol) get mqttSink=>_mqttStreamController.sink.add;

  Stream<MqttProtocol> get mqttStream=> _mqttStreamController.stream;
  void disposeStreams() {
    _mqttStreamController?.close();
  }

  void prepareMqttClient(String _topicIn) async {
    _setupMqttClient();
    await _connectClient();
    if(_topicIn!='NoSelecccionado'){
    subscribeToTopic(_topicIn);}
  }

  void publishData(String data,String topico) {
    
    _publishMessage(data, topico);
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::MQTT client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    String _id=Random(300).nextInt(300).toDouble().toString();
    print('MQTTClientWrapper::Connecting with id SDR/app$_id');
    client = MqttClient.withPort(Constants.serverUri, 'SDR/app$_id', Constants.port);
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String deviceDataJson =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //final decodedData = json.decode(resp.body.toString());
      MqttProtocol decodedData= MqttProtocol.fromJsonMap(json.decode(deviceDataJson));
      print("MQTTClientWrapper::GOT A NEW MESSAGE $deviceDataJson");
      
      if (decodedData != null) onDeviceDataReceivedCallback(decodedData,topicName);
    });
  }


  void _publishMessage(String message, String topicO) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic $topicO');
    client.publishMessage(topicO, MqttQos.exactlyOnce, builder.payload);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    }
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
    onConnectedCallback();
  }

}