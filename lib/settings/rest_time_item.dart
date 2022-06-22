import 'package:flutter/material.dart';
import '../model/model.dart';
import 'helper_calculate_time.dart';

class RestTimeItem extends StatelessWidget {
  const RestTimeItem({Key? key}) : super(key: key);

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
            'Время отдыха:',
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
                Icons.chair,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showTimeBottomSheet(
                      context, 'rest', model.restMinutes, model.restSeconds);
                },
                child: Text(
                  '${model.restMinutes}:${model.restSeconds}',
                  style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.addTime(model, 15, 55, 'rest');
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
                      HelperTime.removeTime(model, 15, 55, 'rest');
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
          // const Divider(
          //   height: 10,
          //   color: Colors.black,
          // ),
        ],
      ),
    );
  }
}