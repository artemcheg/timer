import 'package:flutter/material.dart';

import '../model/model.dart';

class RoundsCountItem extends StatelessWidget {
  const RoundsCountItem({
    Key? key,
  }) : super(key: key);

  void addRounds(Model model) {
    int rounds = int.parse(model.rounds);

    if (rounds == 100) {
      rounds = 1;
    } else {
      rounds++;
    }
    model.setRounds(roundsToString(rounds));
  }

  void removeRounds(Model model) {
    int rounds = int.parse(model.rounds);

    if (rounds > 1) {
      rounds--;
    } else if (rounds == 1) {
      rounds = 100;
    }
    model.setRounds(roundsToString(rounds));
  }

  String roundsToString(int rounds) {
    return rounds < 10 ? '0$rounds' : '$rounds';
  }

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
            'Количество раундов:',
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
                Icons.sports_martial_arts_rounded,
                size: 70,
                color: Colors.pink,
              ),
              InkWell(
                onTap: () {
                  model.showRoundsBottomSheet(context);
                },
                child: Text(
                  model.rounds,
                  style: const TextStyle(fontSize: 35,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      addRounds(model);
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
                      removeRounds(model);
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