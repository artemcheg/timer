import 'dart:async';

import 'package:flutter/material.dart';
import 'package:painter/model/model.dart';
import 'package:painter/model/sound.dart';
import 'dart:math';
import 'gradient_app_bar.dart';
import 'main_painter.dart';
import 'helper.dart';

class MyTimer extends StatefulWidget {
  const MyTimer({Key? key}) : super(key: key);

  @override
  State<MyTimer> createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer>
    with TickerProviderStateMixin
    implements Calc {
  late AnimationController animatedIconController;
  late Animation<double> animationIcon;
  late AnimationController animatedCircleController;
  late Animation<double> animationCircle;
  final Tween<double> _rotationTween = Tween(begin: 0, end: pi * 2);
  int elapsedMinutes = 0;
  int elapsedSeconds = 0;
  late int leftMinutes;
  late int leftSeconds;
  bool isLeftElapsed = false;
  Stopwatch stopwatch = Stopwatch();
  bool isWork = false;
  Model model = Model.modelInstance;
  late int totalMinutes;
  late int totalSeconds;
  late int rounds;
  late int randomDownSeconds;
  late int randomUpSeconds;
  late int randomTime;
  late Timer randomSignalTimer;
  late Stopwatch regularStopwatch = Stopwatch();
  late int restTime;
  late int regularSignalTime;

  @override
  void initState() {
    super.initState();
    restTime = int.parse(model.restMinutes) + int.parse(model.restSeconds);
    totalMinutes = int.parse(model.roundTimeMinutes);
    totalSeconds = int.parse(model.roundTimeSeconds);
    leftMinutes = totalMinutes;
    leftSeconds = totalSeconds;
    rounds = model.roundsCount;
    randomDownSeconds = (int.parse(model.randomDownMinutes) * 60) +
        int.parse(model.randomDownSeconds);
    randomUpSeconds = (int.parse(model.randomUpMinutes) * 60) +
        int.parse(model.randomUpSeconds);
    randomTime = Random().nextInt(randomUpSeconds - randomDownSeconds + 1) +
        randomDownSeconds;

    regularSignalTime = (int.parse(model.regularSignalMinutes) * 60) +
        int.parse(model.regularSignalSeconds);
    regularSignalStart();
    randomSignalStart();
    animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationIcon =
        CurvedAnimation(parent: animatedIconController, curve: Curves.easeIn);

    final Duration duration =
    Duration(minutes: totalMinutes, seconds: totalSeconds);

    animatedCircleController =
        AnimationController(vsync: this, duration: duration);
    animationCircle = _rotationTween.animate(animatedCircleController);
    animationCircle.addListener(() {
      setState(() {});
    });

    startTimer();

    animationCircle.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopwatch.reset();
        stopwatch.stop();
        regularStopwatch.reset();
        regularStopwatch.stop();
        animatedIconController.reverse();
        Sound.soundInstance.disposeTick();
        randomSignalStop();
        Sound.soundInstance.playAlarm({'name': 'alarm'}).then((value) {
          if (value == 'завершено') {
            calculateRounds();
          }
        });
      }
    });
  }


  void regularSignalStart() {
    if (regularSignalTime != 0) {
      regularStopwatch.start();
    }
  }

  void calculateRegularSignal() {
    if (regularStopwatch.elapsed.inSeconds == regularSignalTime) {
      Sound.soundInstance.playRegular();
      regularStopwatch.reset();
      print('****************');
      print(regularStopwatch.elapsed.inSeconds);
    }
  }


  void randomSignalStart() {
    if (randomUpSeconds != 0 && randomUpSeconds > randomDownSeconds) {
      randomSignalTimer = Timer(Duration(seconds: randomTime), () {
        Sound.soundInstance.playAlarm({'name': 'clap'}).then((value) =>
        randomTime =
            Random().nextInt(randomUpSeconds - randomDownSeconds + 1) +
                randomDownSeconds);
        randomSignalStart();
      });
    }
  }

  void randomSignalStop() {
    try {
      randomSignalTimer.cancel();
    } catch (_) {}
  }

  void calculateRounds() {
    if (rounds < int.parse(model.rounds) && restTime != 0) {
      rounds += 1;
      model.setRoundsCount(rounds);
      Navigator.pushReplacementNamed(context, '/restTimer');
    }
    if (rounds < int.parse(model.rounds) && restTime == 0) {
      rounds += 1;
      model.setRoundsCount(rounds);
      Navigator.pushReplacementNamed(context, '/startTimer');
    } else {
      return;
    }
  }

  @override
  void startTimer() {
    animatedIconController.forward();
    stopwatch.start();
    animatedCircleController.forward();
  }

  @override
  void calculateTime() {
    if (regularSignalTime!=0&&regularStopwatch.elapsed.inSeconds == regularSignalTime) {
      Sound.soundInstance.playRegular();
      regularStopwatch.reset();
    }

    if (animationCircle.status == AnimationStatus.completed) {
      elapsedSeconds = totalSeconds;
      elapsedMinutes = totalMinutes;
      leftMinutes = 0;
      leftSeconds = 0;
    } else {
      elapsedSeconds = stopwatch.elapsed.inSeconds % 60;
      elapsedMinutes = (stopwatch.elapsed.inSeconds / 60).floor();
      leftMinutes =
          (((totalMinutes * 60 + totalSeconds) - stopwatch.elapsed.inSeconds) /
              60)
              .floor();
      leftSeconds = (totalSeconds - elapsedSeconds) % 60;

      if (leftMinutes == 0 && leftSeconds <= 10) {
        Sound.soundInstance.playTick();
      }
    }
    if (leftMinutes == 0 && leftSeconds == 1) {
      randomSignalStop();
    }
  }

  @override
  void startStopButton() {
    if (animatedCircleController.isAnimating) {
      animatedIconController.reverse();
      animatedCircleController.stop();
      stopwatch.stop();
      regularStopwatch.stop();
      randomSignalStop();
      Sound.soundInstance.disposeTick();
    } else {
      startTimer();
      randomSignalStart();
      regularSignalStart();
      if (animationCircle.status == AnimationStatus.completed) {
        animatedCircleController.reset();
        animatedCircleController.forward();
      }
    }
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
    randomSignalStop();
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
          child: gradientAppBar('Раунд $rounds из ${int.parse(model.rounds)}', context, () {
            Navigator.pop(context);
            willPop();
          })),
      body: WillPopScope(
        onWillPop: () {
          return willPop();
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/22.jpg'), fit:BoxFit.cover)),
          child: Center(
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          isLeftElapsed = !isLeftElapsed;
                        },
                        child: CustomPaint(
                          painter: MyPainter(
                            end: animationCircle.value,
                            minutes: isLeftElapsed
                                ? leftMinutes
                                : elapsedMinutes,
                            seconds: isLeftElapsed
                                ? leftSeconds
                                : elapsedSeconds,
                          ),
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
