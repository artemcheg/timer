import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'MainPainter.dart';

class HomePage extends StatefulWidget {
  final int minutes;
  final int seconds;

  const HomePage({Key? key, required this.minutes, required this.seconds})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
  var methodChannel = const MethodChannel('timer');
  bool isWork = false;

  @override
  void initState() {
    super.initState();
    leftMinutes = widget.minutes;
    leftSeconds = widget.seconds;

    animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationIcon =
        CurvedAnimation(parent: animatedIconController, curve: Curves.easeIn);

    final Duration duration =
        Duration(minutes: widget.minutes, seconds: widget.seconds);

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
        animatedIconController.reverse();
        methodChannel.invokeMethod('dispose');
      }
    });
  }

  void startTimer() async {
    await animatedIconController.forward();
    stopwatch.start();
    animatedCircleController.forward();
  }

  void calculateTime() {
    if (animationCircle.status == AnimationStatus.completed) {
      elapsedSeconds = widget.seconds;
      elapsedMinutes = widget.minutes;
    } else {
      elapsedSeconds = stopwatch.elapsed.inSeconds % 60;
      elapsedMinutes = (stopwatch.elapsed.inSeconds / 60).floor();
      leftMinutes = (((widget.minutes * 60 + widget.seconds) -
                  stopwatch.elapsed.inSeconds) /
              60)
          .floor();
      leftSeconds = (widget.seconds - elapsedSeconds) % 60;

      if (leftMinutes == 0 && leftSeconds <= 5) {
        methodChannel.invokeMethod('play');
      }
    }
  }

  void startStopButton() {
    if (animatedCircleController.isAnimating) {
      animatedIconController.reverse();
      animatedCircleController.stop();
      stopwatch.stop();
      methodChannel.invokeMethod('dispose');
    } else {
      stopwatch.start();
      animatedIconController.forward();
      animatedCircleController.forward();

      if (animationCircle.status == AnimationStatus.completed) {
        animatedCircleController.reset();
        animatedCircleController.forward();
      }
    }
  }

  @override
  void dispose() async {
    animatedCircleController.dispose();
    animatedIconController.dispose();
    methodChannel.invokeMethod('dispose');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateTime();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Таймер')),
      ),
      body: Center(
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: RepaintBoundary(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () {
                      setState(() {
                        isLeftElapsed = !isLeftElapsed;
                      });
                    },
                    child: CustomPaint(
                      painter: MyPainter(
                        end: animationCircle.value,
                        minutes: isLeftElapsed ? leftMinutes : elapsedMinutes,
                        seconds: isLeftElapsed ? leftSeconds : elapsedSeconds,
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
                      color: Colors.teal,
                      size: 200,
                      icon: AnimatedIcons.play_pause,
                      progress: animationIcon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
