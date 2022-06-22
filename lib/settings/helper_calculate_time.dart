import '../model/model.dart';

class HelperTime {
  static final List<String> secondsListRoundsTime =
      List<String>.generate(13, (index) {
    if (index * 5 < 10) {
      return '0${index * 5}';
    } else {
      return '${index * 5}';
    }
  });

  static final List<String> secondsListMinutesTime =
      List<String>.generate(61, (index) {
    if (index + 1 < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  static int parse(String whatTime, List<String> secOrMin) {
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

  static void addTime(Model model, int maxMin, int maxSec, String whatTime) {
    late String min;
    late String sec;
    switch (whatTime) {
      case 'roundTime':
        min = model.roundTimeMinutes;
        sec = model.roundTimeSeconds;
        break;
      case 'rest':
        min = model.restMinutes;
        sec = model.restSeconds;
        break;
      case 'randomUp':
        min = model.randomUpMinutes;
        sec = model.randomUpSeconds;
        break;
      case 'randomDown':
        min = model.randomDownMinutes;
        sec = model.randomDownSeconds;
        break;
      case 'regular':
        min = model.regularSignalMinutes;
        sec = model.regularSignalSeconds;
        break;
    }

    // если количество секунд < maxSec и минуты !=maxMin
    if (int.parse(sec) < maxSec && int.parse(min) != maxMin) {
      // проверяем какое число было выбрано в скролле
      // если кратное 5, то просто увеличиваем индекс на 1
      // и получаем число на 5сек больше
      if (int.parse(sec) % 5 == 0) {
        sec = secondsListRoundsTime[secondsListRoundsTime.indexOf(sec) + 1];
        //  если число не кратное 5 используем метод "parse()" для нахождения
        //  индекса числа которое является максимальной нижней границей
        //  выбраного и кратное 5 например(49 выбрали и 45 получили)
        //  и увеличиваем индекс на 1, получем следующее
        //  число с разницей в 5 секунд(50)
      } else {
        sec = secondsListRoundsTime[parse(sec, secondsListRoundsTime) + 1];
      }
      //  если количество секунд больше 55(максимум 60 но оно нигде не появляется)
    } else {
      // и минуты < maxMin
      if (int.parse(min) < maxMin) {
        // увеличиваем количество минут на один повышая индекс в списке
        min = secondsListMinutesTime[secondsListMinutesTime.indexOf(min) + 1];
        // обнуляем секунды
        sec = '00';
        //  если же минуты = maxMin, обнуляем и минуты и секунды, т.к. час максимум
      } else if (int.parse(min) == maxMin) {
        sec = '00';
        min = '00';
      }
    }
    switch (whatTime) {
      case 'roundTime':
        model.setSecondsRoundTime(sec);
        model.setMinutesRoundTime(min);
        break;
      case 'rest':
        model.setRestSeconds(sec);
        model.setRestMinutes(min);
        break;
      case 'randomUp':
        model.setRandomUpMinutes(min);
        model.setRandomUpSeconds(sec);
        break;
      case 'randomDown':
        model.setRandomDownMinutes(min);
        model.setRandomDownSeconds(sec);
        break;
      case 'regular':
        model.setRegularSignalMinutes(min);
        model.setRegularSignalSeconds(sec);
        break;
    }
  }

  static void removeTime(Model model, int maxMin, int maxSec, String whatTime) {
    late String min;
    late String sec;
    switch (whatTime) {
      case 'roundTime':
        min = model.roundTimeMinutes;
        sec = model.roundTimeSeconds;
        break;
      case 'rest':
        min = model.restMinutes;
        sec = model.restSeconds;
        break;
      case 'randomUp':
        min = model.randomUpMinutes;
        sec = model.randomUpSeconds;
        break;
      case 'randomDown':
        min = model.randomDownMinutes;
        sec = model.randomDownSeconds;
        break;
      case 'regular':
        min = model.regularSignalMinutes;
        sec = model.regularSignalSeconds;
        break;
    }
    // если на счетчике 0 секунд секунды идут в обратную сторону, значит ставим maxSec
    if (int.parse(sec) == 0) {
      sec = '$maxSec';
      // если минуты = 0 также возвращем максимум для минут
      if (int.parse(min) == 0) {
        min = '$maxMin';
        sec = '00';
        // если минуты не = 0, тогда уменьшаем количество минут на 1ед.
      } else {
        min = secondsListMinutesTime[secondsListMinutesTime.indexOf(min) - 1];
      }
      // если секунд > 0
    } else if (int.parse(sec) > 0) {
      // проверяем кратное ли оно 5 или выставлено через скролл
      // если не кратно, то через метод "parse()" получаем индекс числа,
      // которое нам нужно получить при нажатии кнопки минус например(было выбрано 49 остаток 4,
      // 49 - 4 = 45, берем именно это число без уменьшения)
      if (int.parse(sec) % 5 != 0) {
        sec = secondsListRoundsTime[parse(sec, secondsListRoundsTime)];
      } else {
        // если кратно просто уменьшаем количество секунд на 5
        sec = secondsListRoundsTime[secondsListRoundsTime.indexOf(sec) - 1];
      }
    }
    switch (whatTime) {
      case 'roundTime':
        model.setSecondsRoundTime(sec);
        model.setMinutesRoundTime(min);
        break;
      case 'rest':
        model.setRestSeconds(sec);
        model.setRestMinutes(min);
        break;
      case 'randomUp':
        model.setRandomUpMinutes(min);
        model.setRandomUpSeconds(sec);
        break;
      case 'randomDown':
        model.setRandomDownMinutes(min);
        model.setRandomDownSeconds(sec);
        break;
      case 'regular':
        model.setRegularSignalMinutes(min);
        model.setRegularSignalSeconds(sec);
        break;
    }
  }
}
