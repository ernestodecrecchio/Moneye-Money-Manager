import 'package:intl/intl.dart';

/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

DateTime previousDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day - 1,
    currentDate.hour,
    currentDate.minute,
    currentDate.second,
  );
}

DateTime nextDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day + 1,
    currentDate.hour,
    currentDate.minute,
    currentDate.second,
  );
}

/// WEEK MANAGEMENT

DateTime currentWeekFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day - currentDate.weekday + 1,
    0,
    0,
    0,
  );
}

DateTime currentWeekLastDay(DateTime currentDate) {
  print(currentDate.weekday);
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day - currentDate.weekday + 7,
    23,
    59,
    59,
  );
}

DateTime previousWeekFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day - currentDate.weekday - 6,
    0,
    0,
    0,
  );
}

DateTime previousWeekLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day - currentDate.weekday,
    23,
    59,
    59,
  );
}

DateTime nextWeekFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day + (currentDate.weekday % 7) + 6,
    0,
    0,
    0,
  );
}

DateTime nextWeekLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day + currentDate.weekday,
    23,
    59,
    59,
  );
}

// MONTH MANAGEMENT

DateTime currentMonthFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    1,
    0,
    0,
    0,
  );
}

DateTime currentMonthLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month + 1,
    0,
    23,
    59,
    59,
  );
}

DateTime previousMonthFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month - 1,
    1,
    0,
    0,
    0,
  );
}

DateTime previousMonthLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month,
    0,
    23,
    59,
    50,
  );
}

DateTime nextMonthFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month + 1,
    1,
    0,
    0,
    0,
  );
}

DateTime nextMonthLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    currentDate.month + 2,
    0,
    23,
    59,
    59,
  );
}

// YEAR MANAGEMENT

DateTime currentYearFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    1,
    1,
    0,
    0,
    0,
  );
}

DateTime currentYearLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year,
    13,
    0,
    23,
    59,
    59,
  );
}

DateTime previousYearFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year - 1,
    1,
    1,
    0,
    0,
    0,
  );
}

DateTime previousYearLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year - 1,
    13,
    0,
    23,
    59,
    59,
  );
}

DateTime nextYearFirstDay(DateTime currentDate) {
  return DateTime(
    currentDate.year + 1,
    1,
    1,
    0,
    0,
    0,
  );
}

DateTime nextYearLastDay(DateTime currentDate) {
  return DateTime(
    currentDate.year + 1,
    13,
    0,
    23,
    59,
    59,
  );
}

extension DateTimeComparison on DateTime {
  bool isBeforeIncludingZero(DateTime other) {
    if (hour != 0 && minute != 0 && second != 0) {
      return isBefore(other);
    } else {
      return DateTime(year, month, day, hour, minute, 1).isBefore(other);
    }
  }

  bool isAfterIncludingZero(DateTime other) {
    if (hour != 0 && minute != 0 && second != 0) {
      return isAfter(other);
    } else {
      return DateTime(year, month, day, hour, minute, 1).isAfter(other);
    }
  }
}
