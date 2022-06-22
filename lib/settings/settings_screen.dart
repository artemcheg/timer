import 'package:flutter/material.dart';
import 'package:painter/model/model.dart';
import 'package:painter/settings/random_time_item.dart';
import 'package:painter/settings/regular_signal.dart';
import 'package:painter/settings/rest_time_item.dart';
import 'package:painter/settings/rounds_count_item.dart';
import 'package:painter/settings/rounds_time_item.dart';
import 'package:painter/screens/gradient_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelWidget(
      model: Model.modelInstance,
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          enableFeedback: true,
          backgroundColor: Colors.pink,
          foregroundColor: Colors.black,
          onPressed: () {
            Model.modelInstance.setRoundsCount(1);
            Navigator.pushNamed(context, '/tenSecondsStart');
          },
          child: const Icon(Icons.done_rounded,size: 30,),
        ),
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 60),
            child: const GradientAppBar(
              showBackButton: false,
              text: 'Настройка тренировки'),
            ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/17.jpg'), fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    RoundsCountItem(),
                    RoundsTimeItem(),
                    RestTimeItem(),
                    RegularSignal(),
                    RandomDownTimeItem(),
                    RandomUpTimeItem(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
