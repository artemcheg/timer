import 'package:flutter/material.dart';
import 'package:painter/main.dart';
import 'package:painter/model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Model _model = Model();


  void checkTime(){
    int minutes = int.parse(_model.minutes);
    int seconds = int.parse(_model.seconds);
   Navigator.pushNamed(context, '/startTimer',arguments: Arguments(minutes, seconds));
  }


  @override
  Widget build(BuildContext context) {
    return ModelWidget(
      model: _model,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () { checkTime(); },child: const Icon(Icons.done_outline),),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              SettingItem(),
              TimeItem(),
            ],
          ),
        ),
      ),
    );
  }
}




class SettingItem extends StatefulWidget {
  const SettingItem({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  int rounds = 1;

  void addRounds() {
    setState(() {
      if (rounds == 100) {
        rounds = 1;
      } else {
        rounds++;
      }
    });
  }

  void removeRounds() {
    setState(() {
      if (rounds > 1) {
        rounds--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Количество раундов:',
          style: TextStyle(fontSize: 25),
        ),
        const Divider(
          height: 10,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.sports_martial_arts_rounded,
              size: 70,
              color: Colors.blue,
            ),
            Text( rounds<10?
              '0$rounds':'$rounds',
              style: const TextStyle(fontSize: 35),
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    addRounds();
                  },
                  child: const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    removeRounds();
                  },
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          height: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}

class TimeItem extends StatefulWidget {
  const TimeItem({Key? key}) : super(key: key);

  @override
  State<TimeItem> createState() => _TimeItemState();
}

class _TimeItemState extends State<TimeItem> {
  int indexSec = 0;
  int indexMin = 0;
  late String min;
  late String sec;
  late Model inheritedWidget;

  List<String> secondsList = List<String>.generate(13, (index) {
    if (index * 5 < 10) {
      return '0${index * 5}';
    } else {
      return '${index * 5}';
    }
  });

  List<String> minutesList = List<String>.generate(61, (index) {
    if (index + 1 < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  int parse(String whatTime, List<String> secOrMin) {
    // при выставлении числа через скролл мы должны уменьшать и
    // увеличивать его через кнопки по 5 сек
    // для этого находим остаток от числа которое было выбрано:
    var ost = int.parse(whatTime) % 5;
    // потом от числа которое было выбрано через скролл отнимаем
    // остаток и получаем число кратное 5
    var element = (int.parse(whatTime) - ost).toString();
    // теперь получаем индекс этого числа в нашем списке,
    // если оно < 10 добавляем перед ним 0
    return secOrMin.indexOf(int.parse(element) < 10 ? '0$element' : element);
  }

  void addTime() {
    setState(() {
      // если количество секунд < 55 и минуты !=60
      if (int.parse(sec) < 55 && int.parse(min) != 60) {
        // проверяем какое число было выбрано в скролле
        // если кратное 5, то просто увеличиваем индекс на 1
        // и получаем число на 5сек больше
        if (int.parse(sec) % 5 == 0) {
          sec = secondsList[secondsList.indexOf(sec) + 1];
          //  если число не кратное 5 используем метод "parse()" для нахождения
          //  индекса числа которое является максимальной нижней границей
          //  выбраного и кратное 5 например(49 выбрали и 45 получили)
          //  и увеличиваем индекс на 1, получем следующее
          //  число с разницей в 5 секунд(50)
        } else {
          sec = secondsList[parse(sec,secondsList) + 1];
        }
      //  если количество секунд больше 55(максимум 60 но оно нигде не появляется)
      } else {
      // и минуты < 60
        if (int.parse(min) < 60) {
          // увеличиваем количество минут на один повышая индекс в списке
          min = minutesList[minutesList.indexOf(min) + 1];
          // обнуляем секунды
          sec = '00';
        //  если же минуты = 60, обнуляем и минуты и секунды, т.к. час максимум
        } else if (int.parse(min) == 60) {
          sec = '00';
          min = '00';
        }
      }
      inheritedWidget.setSeconds(sec);
      inheritedWidget.setMinutes(min);
    });
  }

  void removeTime() {
    setState(() {
      // если на счетчике 0 секунд секунды идут в обратную сторону, значит ставим 55
      if (int.parse(sec) == 0) {
        sec = '55';
      // если минуты = 0 также возвращем максимум для минут
        if (int.parse(min) == 0) {
          min = '60';
      // если минуты не = 0, тогда уменьшаем количество минут на 1ед.
        } else {
          min = minutesList[minutesList.indexOf(min) - 1];
        }
      // если секунд > 0
      } else if (int.parse(sec) > 0) {
      // проверяем кратное ли оно 5 или выставлено через скролл
      // если не кратно, то через метод "parse()" получаем индекс числа,
      // которое нам нужно получить при нажатии кнопки минус например(было выбрано 49 остаток 4,
      // 49 - 4 = 45, берем именно это число без уменьшения)
        if (int.parse(sec) % 5 != 0) {
          sec = secondsList[parse(sec,secondsList)];
        } else {
          // если кратно просто уменьшаем количество секунд на 5
          sec = secondsList[secondsList.indexOf(sec) - 1];
        }
      }
      inheritedWidget.setSeconds(sec);
      inheritedWidget.setMinutes(min);
    });
  }

  String seconds() {
    // на экран выводим большее число и двух(скролла и числа которое ставим через кнопки)
    // эти 2 метода используются только при старте экрана
    if (int.parse(sec) < int.parse(secondsList[indexSec]) ||
        minutes() == '60') {
      return sec = secondsList[indexSec];
    } else {
      return sec;
    }
  }

  String minutes() {
    if (int.parse(min) < int.parse(minutesList[indexMin])) {
      return min = minutesList[indexMin];
    } else {
      return min;
    }
  }

  @override
  void didChangeDependencies() {
    inheritedWidget = ModelWidget.watch(context)!;
    // берем секунды и минуты из модели
    sec = inheritedWidget.seconds;
    min = inheritedWidget.minutes;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Время раунда:',
          style: TextStyle(fontSize: 25),
        ),
        const Divider(
          height: 10,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.timer_outlined,
              size: 70,
              color: Colors.blue,
            ),
            InkWell(
              onTap: () {
                inheritedWidget.showBottomSheet(context, minutes(), seconds());
              },
              child: Text(
                '${minutes()}:${seconds()}',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    addTime();
                  },
                  child: const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    removeTime();
                  },
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          height: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}

