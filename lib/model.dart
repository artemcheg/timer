import 'package:flutter/material.dart';


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

  @override
  bool updateShouldNotify(ModelWidget oldWidget) {
    return model.seconds != oldWidget.model.seconds ||
        model.minutes != oldWidget.model.minutes;
  }
}

class Model extends ChangeNotifier {
  String seconds = '00';
  String minutes = '00';

  void setSeconds(String seconds) {
    this.seconds = seconds;
    notifyListeners();
  }

  void setMinutes(String minutes) {
    this.minutes = minutes;
    notifyListeners();
  }

  void showBottomSheet(BuildContext context, String minutes, String seconds) {
    this.seconds = seconds;
    this.minutes = minutes;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ModelWidget(
            model: this,
            child: TimeDialog(
              seconds: seconds,
              minutes: minutes,
            ),
          );
        });
    notifyListeners();
  }
}

class TimeDialog extends StatefulWidget {
  final String seconds;
  final String minutes;

  const TimeDialog({Key? key, required this.seconds, required this.minutes})
      : super(key: key);

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  List<String> timeSecondsList = List<String>.generate(60, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  List<String> timeMinutesList = List<String>.generate(61, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });
  late Model inheritedWidget;
  late FixedExtentScrollController controllerMin;
  late FixedExtentScrollController controllerSec;
  late final ModelWidget myInherit;

  @override
  void initState() {
    controllerMin = FixedExtentScrollController(
        initialItem: timeMinutesList.indexOf(widget.minutes));
    controllerSec = FixedExtentScrollController(
        initialItem: timeSecondsList.indexOf(widget.seconds));

    controllerMin.addListener(() {
      if (controllerMin.selectedItem == 60) {
        controllerSec.animateToItem(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controllerMin.dispose();
    controllerSec.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    inheritedWidget = ModelWidget.read(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Минуты:',
                    style: TextStyle(fontSize: 25),
                  ),
                  Flexible(
                    child: ListWheelScrollView(
                        controller: controllerMin,
                        physics: const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.1,
                        squeeze: 0.5,
                        diameterRatio: 1.5,
                        offAxisFraction: 0.6,
                        onSelectedItemChanged: (index) {
                          inheritedWidget.setMinutes(timeMinutesList[index]);
                        },
                        itemExtent: 50,
                        magnification: 1.5,
                        useMagnifier: true,
                        children: timeMinutesList
                            .map((minutes) => Text(
                                  minutes,
                                  style: const TextStyle(fontSize: 25),
                                ))
                            .toList()),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Секунды:',
                    style: TextStyle(fontSize: 25),
                  ),
                  Flexible(
                    child: ListWheelScrollView(
                        controller: controllerSec,
                        physics: ModelWidget.watch(context)!.minutes == '60'
                            ? const NeverScrollableScrollPhysics()
                            : const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.1,
                        squeeze: 0.5,
                        diameterRatio: 1.5,
                        offAxisFraction: -0.6,
                        onSelectedItemChanged: (index) {
                          if (inheritedWidget.minutes == '60') {
                            inheritedWidget.setSeconds('00');
                          } else {
                            inheritedWidget.setSeconds(timeSecondsList[index]);
                          }
                        },
                        itemExtent: 50,
                        magnification: 1.5,
                        useMagnifier: true,
                        children: timeSecondsList
                            .map((seconds) => Text(
                                  seconds,
                                  style: const TextStyle(fontSize: 25),
                                ))
                            .toList()),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Center(
            child: Text(
          ':',
          style: TextStyle(fontSize: 40),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }
}
