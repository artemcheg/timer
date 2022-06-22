import 'dart:math';

import 'package:flutter/material.dart';
import 'package:painter/model/sound.dart';

import 'gradient_app_bar.dart';
import 'main_painter.dart';
import 'helper.dart';
import '../model/model.dart';

class RestTimeTimer extends StatefulWidget {
  const RestTimeTimer({Key? key}) : super(key: key);

  @override
  State<RestTimeTimer> createState() => _RestTimeTimerState();
}

class _RestTimeTimerState extends State<RestTimeTimer>
    with TickerProviderStateMixin
    implements Calc {
  late AnimationController animatedIconController;
  late Animation<double> animationIcon;
  late AnimationController animatedCircleController;
  late Animation<double> animationCircle;
  final Tween<double> _rotationTween = Tween(begin: 0, end: pi * 2);
  late int leftMinutes;
  late int leftSeconds;
  late int totalMinutes;
  late int totalSeconds;
  Stopwatch stopwatch = Stopwatch();
  Model model = Model.modelInstance;

  @override
  void initState() {
    super.initState();
    totalMinutes = int.parse(model.restMinutes);
    totalSeconds = int.parse(model.restSeconds);
    leftMinutes = totalMinutes;
    leftSeconds = totalSeconds;

    animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationIcon =
        CurvedAnimation(parent: animatedIconController, curve: Curves.easeIn);

    animatedCircleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: totalSeconds, minutes: totalMinutes));
    animationCircle = _rotationTween.animate(animatedCircleController);
    animationCircle.addListener(() {
      setState(() {});
    });
    startTimer();

    animatedCircleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopwatch.reset();
        stopwatch.stop();
        Sound.soundInstance.disposeTick();
        Sound.soundInstance.playAlarm({'name': 'alarm'}).then((value) {
          if (value == 'завершено') {
            Navigator.pushReplacementNamed(context, '/startTimer');
          }
        });
      }
    });
  }

  @override
  void calculateTime() {
    if (animationCircle.status == AnimationStatus.completed) {
      leftSeconds = 0;
      leftMinutes = 0;
    } else {
      leftSeconds = (totalSeconds - stopwatch.elapsed.inSeconds) % 60;
      leftMinutes =
          (((totalMinutes * 60 + totalSeconds) - stopwatch.elapsed.inSeconds) /
                  60)
              .floor();

      if (leftSeconds <= 10 && leftMinutes == 0) {
        Sound.soundInstance.playTick();
      }
    }
  }

  @override
  void startStopButton() {
    if (animatedCircleController.isAnimating) {
      animatedIconController.reverse();
      animatedCircleController.stop();
      stopwatch.stop();
      Sound.soundInstance.disposeTick();
    } else {
      startTimer();
    }
  }

  @override
  void startTimer() {
    animatedIconController.forward();
    stopwatch.start();
    animatedCircleController.forward();
  }

  @override
  Future<bool> willPop() async {
    stopwatch.stop();
    try {
      animatedCircleController.dispose();
      animatedIconController.dispose();
    } catch (_) {}
    Sound.soundInstance.disposeTick();
    Sound.soundInstance.disposeAlarm();
    return true;
  }

  @override
  void dispose() {
    willPop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateTime();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery
              .of(context)
              .size
              .width, 60),
          child: gradientAppBar('Отдых', context, () {
            Navigator.pop(context);
            willPop();
          })),
      body: WillPopScope(
        onWillPop: () {
          return willPop();
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/15.jpg'), fit: BoxFit.cover)),
          child: Center(
            child: FittedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: RepaintBoundary(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(1000),
                        onTap: () {
                          startStopButton();
                        },
                        child: CustomPaint(
                          painter: MyPainter(
                              end: animationCircle.value,
                              minutes: leftMinutes,
                              seconds: leftSeconds),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      startStopButton();
                    },
                    child: RepaintBoundary(
                      child: AnimatedIcon(
                          color: Colors.pink,
                          size: 200,
                          icon: AnimatedIcons.play_pause,
                          progress: animationIcon),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
