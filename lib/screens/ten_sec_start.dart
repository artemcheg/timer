import 'dart:math';
import 'package:flutter/material.dart';
import 'package:painter/screens/main_painter.dart';
import 'package:painter/screens/helper.dart';
import 'package:painter/model/sound.dart';

import 'gradient_app_bar.dart';

class TenSecStart extends StatefulWidget {
  const TenSecStart({
    Key? key,
  }) : super(key: key);

  @override
  State<TenSecStart> createState() => _TenSecStartState();
}

class _TenSecStartState extends State<TenSecStart>
    with TickerProviderStateMixin
    implements Calc {
  late AnimationController animatedIconController;
  late Animation<double> animationIcon;
  late AnimationController animatedCircleController;
  late Animation<double> animationCircle;
  final Tween<double> _rotationTween = Tween(begin: 0, end: pi * 2);
  int leftSeconds = 10;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();

    animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationIcon =
        CurvedAnimation(parent: animatedIconController, curve: Curves.easeIn);

    animatedCircleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animationCircle = _rotationTween.animate(animatedCircleController);
    animationCircle.addListener(() {
      setState(() {});
    });
    startTimer();

    animatedCircleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopwatch.reset();
        stopwatch.stop();
        animatedIconController.reverse();
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
  void startTimer() {
    animatedIconController.forward();
    stopwatch.start();
    animatedCircleController.forward();
  }

  @override
  void calculateTime() {
    if (animationCircle.status == AnimationStatus.completed) {
      leftSeconds = 0;
    } else {
      leftSeconds = (10 - stopwatch.elapsed.inSeconds) % 60;

      if (leftSeconds <= 10) {
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
          child: gradientAppBar('Старт через:', context, () {
            Navigator.pop(context);
            willPop();
          })),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(
            image: AssetImage('assets/13.jpg'), fit: BoxFit.cover)),
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
                            minutes: 0,
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
    );
  }
}