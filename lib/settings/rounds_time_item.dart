import 'package:flutter/material.dart';
import '../model/model.dart';
import 'helper_calculate_time.dart';

class RoundsTimeItem extends StatelessWidget {
  const RoundsTimeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Model model = ModelWidget.watch(context)!;
    return Card(
      color: Colors.white.withOpacity(0.7),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Время раунда:',
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
          ),
          const Divider(
            thickness: 3,
            height: 10,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.alarm_rounded,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showTimeBottomSheet(context, 'roundTime',
                      model.roundTimeMinutes, model.roundTimeSeconds);
                },
                child: Text(
                  '${model.roundTimeMinutes}:${model.roundTimeSeconds}',
                  style:  const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.addTime(model, 60, 55, 'roundTime');
                    },
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 60,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.removeTime(model, 60, 55, 'roundTime');
                    },
                    child: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
