import 'package:flutter/material.dart';
import 'package:painter/model.dart';
import 'package:painter/settings_screen.dart';
import 'package:painter/timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelWidget(
      model: Model(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'PT'),
        routes: {
          '/': (context) => const SettingsScreen(),
          // '/startTimer':(context)=> const HomePage()
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/startTimer') {
            final args = settings.arguments as Arguments;
            return MaterialPageRoute(builder: (builder) {
              return HomePage(minutes: args.minutes, seconds: args.seconds);
            });
          }
        },
      ),
    );
  }
}

class Arguments {
  final int minutes;
  final int seconds;

  Arguments(this.minutes, this.seconds);
}
