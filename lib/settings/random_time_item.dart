import 'package:flutter/material.dart';
import '../model/model.dart';
import 'helper_calculate_time.dart';

class RandomDownTimeItem extends StatelessWidget {
  const RandomDownTimeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Model model = ModelWidget.watch(context)!;
    return Card(
      color: Colors.white.withOpacity(0.7),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Рандомный сигнал в промежутке от:',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          const Divider(
            height: 10,
            thickness: 3,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.vertical_align_bottom_rounded,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showTimeBottomSheet(context, 'randomDown',
                      model.randomDownMinutes, model.randomDownSeconds);
                },
                child: Text(
                  '${model.randomDownMinutes}:${model.randomDownSeconds}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.addTime(model, 15, 55, 'randomDown');
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
                      HelperTime.removeTime(model, 15, 55, 'randomDown');
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

class RandomUpTimeItem extends StatelessWidget {
  const RandomUpTimeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Model model = ModelWidget.watch(context)!;
    return Card(
      color: Colors.white.withOpacity(0.7),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'До:',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
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
                Icons.vertical_align_top_rounded,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showTimeBottomSheet(context, 'randomUp',
                      model.randomUpMinutes, model.randomUpSeconds);
                },
                child: Text(
                  '${model.randomUpMinutes}:${model.randomUpSeconds}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      HelperTime.addTime(model, 15, 55, 'randomUp');
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
                      HelperTime.removeTime(model, 15, 55, 'randomUp');
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
