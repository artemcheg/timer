import 'package:flutter/services.dart';

class Sound {
  static final Sound soundInstance = Sound._();

  Sound._();

  final _methodChannelTick = const MethodChannel('timerTick');
  final _methodChannelAlarm = const MethodChannel('timerAlarm');
  final _methodChannelRegular = const MethodChannel('timerRegular');

  void playTick() {
    _methodChannelTick.invokeMethod('playTick');
  }
  void playRegular() {
    _methodChannelRegular.invokeMethod('playRegular');
  }

  Future<dynamic> playAlarm(Map whatMusic) {
    return _methodChannelAlarm.invokeMethod('playAlarm', whatMusic);
  }

  void disposeTick() {
    _methodChannelTick.invokeMethod('disposeTick');
  }
  void disposeRegular() {
    _methodChannelRegular.invokeMethod('disposeRegular');
  }

  void disposeAlarm() {
    _methodChannelAlarm.invokeMethod('disposeAlarm');
  }
}
