import 'package:flutter/material.dart';
import '../model/model.dart';
import 'helper_calculate_time.dart';

class RegularSignal extends StatelessWidget {
  const RegularSignal({Key? key}) : super(key: key);

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
            'Регулярный сигнал:',
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
                Icons.repeat_rounded,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showTimeBottomSheet(context, 'regular',
                      model.regularSignalMinutes, model.regularSignalSeconds);
                },
                child: Text(
                  '${model.regularSignalMinutes}:${model.regularSignalSeconds}',
                  style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.addTime(model, 60, 55, 'regular');
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
                      HelperTime.removeTime(model, 60, 55, 'regular');
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