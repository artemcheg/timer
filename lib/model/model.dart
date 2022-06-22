import 'package:flutter/material.dart';
import 'package:painter/screens/rounds_dialog.dart';
import 'package:painter/screens/time_dialog.dart';

class ModelWidget extends InheritedNotifier<Model> {
  final Model model;

  const ModelWidget({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static Model? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModelWidget>()?.notifier;
  }

  static Model? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<ModelWidget>()?.widget;
    return widget is ModelWidget ? widget.notifier : null;
  }
}

class Model extends ChangeNotifier {
  String roundTimeSeconds = '00';
  String roundTimeMinutes = '00';
  String restMinutes = '00';
  String restSeconds = '00';
  String randomUpSeconds = '00';
  String randomUpMinutes = '00';
  String randomDownSeconds = '00';
  String randomDownMinutes = '00';
  String regularSignalMinutes = '00';
  String regularSignalSeconds = '00';
  String rounds = '01';
  int roundsCount = 1;

  static final Model modelInstance = Model._();

  Model._();

  void setRegularSignalMinutes(String min){
    regularSignalMinutes = min;
    notifyListeners();
  }

  void setRegularSignalSeconds(String sec){
    regularSignalSeconds = sec;
    notifyListeners();
  }

  void setRandomUpSeconds(String sec) {
    randomUpSeconds = sec;
    notifyListeners();
  }

  void setRandomUpMinutes(String min) {
    randomUpMinutes = min;
    notifyListeners();
  }

  void setRandomDownSeconds(String sec) {
    randomDownSeconds = sec;
    notifyListeners();
  }

  void setRandomDownMinutes(String min) {
    randomDownMinutes = min;
    notifyListeners();
  }

  void setRestMinutes(String minutes) {
    restMinutes = minutes;
    notifyListeners();
  }

  void setRestSeconds(String seconds) {
    restSeconds = seconds;
    notifyListeners();
  }

  void setRounds(String rounds) {
    this.rounds = rounds;
    notifyListeners();
  }

  void setRoundsCount(int newRound) {
    roundsCount = newRound;
    notifyListeners();
  }

  void setSecondsRoundTime(String seconds) {
    roundTimeSeconds = seconds;
    notifyListeners();
  }

  void setMinutesRoundTime(String minutes) {
    roundTimeMinutes = minutes;
    notifyListeners();
  }

  void showTimeBottomSheet(
      BuildContext context, String whatTime, String min, String sec) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ModelWidget(
            model: this,
            child: TimeDialog(
              seconds: sec,
              minutes: min,
              whatTime: whatTime,
            ),
          );
        });
  }

  void showRoundsBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ModelWidget(
              model: this,
              child: RoundsDialog(
                rounds: rounds,
              ));
        });
  }
}
