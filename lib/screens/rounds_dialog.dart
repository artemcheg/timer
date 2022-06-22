import 'package:flutter/material.dart';
import '../model/model.dart';

class RoundsDialog extends StatefulWidget {
  final String rounds;

  const RoundsDialog({Key? key, required this.rounds}) : super(key: key);

  @override
  State<RoundsDialog> createState() => _RoundsDialog();
}

class _RoundsDialog extends State<RoundsDialog> {
  List<String> roundsList = List<String>.generate(100, (index) {
    if (index < 10) {
      return '0${index + 1}';
    } else {
      return '${index + 1}';
    }
  });

  late Model inheritedWidget;
  late FixedExtentScrollController controllerRounds;
  late final ModelWidget myInherit;

  @override
  void initState() {
    controllerRounds = FixedExtentScrollController(
        initialItem: roundsList.indexOf(widget.rounds));
    super.initState();
  }

  @override
  void dispose() {
    controllerRounds.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    inheritedWidget = ModelWidget.read(context)!;
    super.didChangeDependencies();
  }
  final style =  const TextStyle(fontSize: 25,fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/16.jpg'), fit:BoxFit.cover)),),
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
                    'Количество раундов:',
                    style: style,
                  ),
                  Flexible(
                    child: ListWheelScrollView(
                        controller: controllerRounds,
                        physics: const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.7,
                        squeeze: 0.5,
                        diameterRatio: 1.5,
                        onSelectedItemChanged: (index) {
                          inheritedWidget.setRounds(roundsList[index]);
                        },
                        itemExtent: 50,
                        magnification: 1.5,
                        useMagnifier: true,
                        children: roundsList
                            .map((minutes) =>
                            Text(
                              minutes,
                              style: style,
                            ))
                            .toList()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}