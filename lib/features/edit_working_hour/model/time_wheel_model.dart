class TimeWheelModel {
  static int normalizeHour(int hour, bool isPM) {
    if (isPM) {
      return hour == 12 ? 12 : hour + 12;
    } else {
      return hour == 12 ? 0 : hour;
    }
  }

  static List<String> generatePaddedNumbers(int start, int end) {
    return List.generate(
      end - start + 1,
      (index) => (start + index).toString().padLeft(2, '0'),
    );
  }

  static List<String> generateHourList() {
    return [
      ...generatePaddedNumbers(10, 12),
      ...generatePaddedNumbers(1, 12),
      ...generatePaddedNumbers(1, 3),
    ];
  }

  static List<String> generateMinuteList() {
    return [
      ...generatePaddedNumbers(57, 59),
      ...generatePaddedNumbers(0, 59),
      ...generatePaddedNumbers(0, 2),
    ];
  }
}
