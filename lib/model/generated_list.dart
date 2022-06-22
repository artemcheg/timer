class GeneratedList {
  final List<String> roundTimeSec = List<String>.generate(60, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  final List<String> roundTimeMinutes =
  List<String>.generate(61, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  final List<String> restTimeSec = List<String>.generate(60, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });

  final List<String> restTimeMin = List<String>.generate(16, (index) {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  });
}