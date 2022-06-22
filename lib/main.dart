import 'package:flutter/material.dart';
import 'package:painter/model/model.dart';
import 'package:painter/screens/rest.dart';
import 'package:painter/settings/settings_screen.dart';
import 'package:painter/screens/ten_sec_start.dart';
import 'package:painter/screens/timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelWidget(
      model: Model.modelInstance,
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'PT',),
          routes: {
            '/': (context) => const SettingsScreen(),
            '/tenSecondsStart':(context)=>const TenSecStart(),
            '/startTimer':(context)=>const MyTimer(),
            '/restTimer':(context)=>const RestTimeTimer(),

          },
          // onGenerateRoute: (settings) {
          //   if (settings.name == '/startTimer') {
          //     final args = settings.arguments as Arguments;
          //     return MaterialPageRoute(builder: (builder) {
          //       return HomePage(minutes: args.minutes, seconds: args.seconds);
          //     });
          //   }else if(settings.name == '/tenSecondsStart'){
          //     final args = settings.arguments as Arguments;
          //     return MaterialPageRoute(builder: (builder) {
          //       return TenSecStart(minutes: args.minutes, seconds: args.seconds);
          //     });
          //   }
          //   return null;
          // },
        ),
      );

  }
}

class Arguments {
  final int minutes;
  final int seconds;

  Arguments(this.minutes, this.seconds);
}
