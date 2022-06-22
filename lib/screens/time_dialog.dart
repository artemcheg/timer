import 'package:flutter/material.dart';
import '../model/generated_list.dart';
import '../model/model.dart';

class TimeDialog extends StatefulWidget {
  final String seconds;
  final String minutes;
  final String whatTime;

  const TimeDialog(
      {Key? key,
      required this.seconds,
      required this.minutes,
      required this.whatTime})
      : super(key: key);

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  late List<String> timeSecondsList;
  late List<String> timeMinutesList;
  late Model inheritedWidget;
  late FixedExtentScrollController controllerMin;
  late FixedExtentScrollController controllerSec;
  late final ModelWidget myInherit;

  void generateList() {
    GeneratedList generator = GeneratedList();
    switch (widget.whatTime) {
      case 'roundTime':
        timeSecondsList = generator.roundTimeSec;
        timeMinutesList = generator.roundTimeMinutes;
        break;
      case 'rest':
        timeSecondsList = generator.restTimeSec;
        timeMinutesList = generator.restTimeMin;
        break;
      case 'randomUp':
        timeSecondsList = generator.restTimeSec;
        timeMinutesList = generator.restTimeMin;
        break;
      case 'randomDown':
        timeSecondsList = generator.restTimeSec;
        timeMinutesList = generator.restTimeMin;
        break;
      case 'regular':
        timeSecondsList = generator.restTimeSec;
        timeMinutesList = generator.restTimeMin;
        break;
    }
  }

  @override
  void initState() {
    generateList();
    controllerMin = FixedExtentScrollController(
        initialItem: timeMinutesList.indexOf(widget.minutes));
    controllerSec = FixedExtentScrollController(
        initialItem: timeSecondsList.indexOf(widget.seconds));

    controllerMin.addListener(() {
      if (controllerMin.selectedItem == timeMinutesList.length - 1) {
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

  void scrollItemChangeSeconds(int index) {
    switch (widget.whatTime) {
      case 'roundTime':
        inheritedWidget.setSecondsRoundTime(timeSecondsList[index]);
        break;
      case 'rest':
        inheritedWidget.setRestSeconds(timeSecondsList[index]);
        break;
      case 'randomUp':
        inheritedWidget.setRandomUpSeconds(timeSecondsList[index]);
        break;
      case 'randomDown':
        inheritedWidget.setRandomDownSeconds(timeSecondsList[index]);
        break;
      case 'regular':
        inheritedWidget.setRegularSignalSeconds(timeSecondsList[index]);
        break;
    }
  }

  void scrollItemChangeMinutes(int index) {
    switch (widget.whatTime) {
      case 'roundTime':
        inheritedWidget.setMinutesRoundTime(timeMinutesList[index]);
        break;
      case 'rest':
        inheritedWidget.setRestMinutes(timeMinutesList[index]);
        break;
      case 'randomUp':
        inheritedWidget.setRandomUpMinutes(timeMinutesList[index]);
        break;
      case 'randomDown':
        inheritedWidget.setRandomDownMinutes(timeMinutesList[index]);
        break;
      case 'regular':
        inheritedWidget.setRegularSignalMinutes(timeMinutesList[index]);
        break;
    }
  }

  ScrollPhysics stackScroll(String whatTime) {
    late String time;
    switch (widget.whatTime) {
      case 'roundTime':
        time = ModelWidget.watch(context)!.roundTimeMinutes;
        break;
      case 'rest':
        time = ModelWidget.watch(context)!.restMinutes;
        break;
      case 'randomUp':
        time = ModelWidget.watch(context)!.randomUpMinutes;
        break;
      case 'randomDown':
        time = ModelWidget.watch(context)!.randomDownMinutes;
        break;
      case 'regular':
        time = ModelWidget.watch(context)!.regularSignalMinutes;
        break;
    }

    return time == timeMinutesList.elementAt(timeMinutesList.length - 1)
        ? const NeverScrollableScrollPhysics()
        : const FixedExtentScrollPhysics();
  }

  final style = const TextStyle(
      fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/23.jpg'), fit: BoxFit.cover)),
        ),
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
                  Text(
                    'Минуты:',
                    style: style,
                  ),
                  Flexible(
                    child: ListWheelScrollView(
                        controller: controllerMin,
                        physics: const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.7,
                        squeeze: 0.5,
                        diameterRatio: 1.5,
                        offAxisFraction: 0.6,
                        onSelectedItemChanged: (index) {
                          scrollItemChangeMinutes(index);
                        },
                        itemExtent: 50,
                        magnification: 1.5,
                        useMagnifier: true,
                        children: timeMinutesList
                            .map((minutes) => Text(
                                  minutes,
                                  style: style,
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
                  Text(
                    'Секунды:',
                    style: style,
                  ),
                  Flexible(
                    child: ListWheelScrollView(
                        controller: controllerSec,
                        physics: stackScroll(widget.whatTime),
                        overAndUnderCenterOpacity: 0.7,
                        squeeze: 0.5,
                        diameterRatio: 1.5,
                        offAxisFraction: -0.6,
                        onSelectedItemChanged: (index) {
                          scrollItemChangeSeconds(index);
                        },
                        itemExtent: 50,
                        magnification: 1.5,
                        useMagnifier: true,
                        children: timeSecondsList
                            .map((seconds) => Text(
                                  seconds,
                                  style: style,
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
