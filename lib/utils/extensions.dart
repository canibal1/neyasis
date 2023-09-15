extension DateTimeExtension on DateTime {
  bool isDate(String pattern) {
    try {
      DateTime.parse(pattern);
      return true;
    } catch (e) {
      return false;
    }
  }
}

extension TCValidation on String {
  bool isValidTC() {
    if (this == null || this.length != 11) {
      return false;
    }

    if (!RegExp(r"^\d{11}$").hasMatch(this)) {
      return false;
    }

    List<int> digits = this.split('').map((e) => int.parse(e)).toList();
    int sum1 = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    int sum2 = digits[1] + digits[3] + digits[5] + digits[7];

    int check1 = (sum1 * 7 - sum2) % 10;
    int check2 = (digits[0] + digits[1] + digits[2] + digits[3] + digits[4] + digits[5] + digits[6] + digits[7] + digits[8] + digits[9]) % 10;

    if (digits[9] != check1 || digits[10] != check2) {
      return false;
    }

    if (digits[0] == 0) {
      return false;
    }

    return true;
  }
}
