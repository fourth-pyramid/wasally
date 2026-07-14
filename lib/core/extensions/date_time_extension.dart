import 'package:wassaly/core/imports/imports.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  String get toIso8601DateOnly => '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  String timeAgo(BuildContext context) {
    final l10n = context.l10n;
    final local = toLocal();
    final now = DateTime.now();
    final difference = now.difference(local);

    if (difference.inDays > 365) {
      return l10n.time_ago_years((difference.inDays / 365).floor());
    } else if (difference.inDays > 30) {
      return l10n.time_ago_months((difference.inDays / 30).floor());
    } else if (difference.inDays > 7) {
      return l10n.time_ago_weeks((difference.inDays / 7).floor());
    } else if (difference.inDays >= 1) {
      return l10n.time_ago_days(difference.inDays);
    } else if (difference.inHours >= 1) {
      return l10n.time_ago_hours(difference.inHours);
    } else if (difference.inMinutes >= 1) {
      return l10n.time_ago_minutes(difference.inMinutes);
    } else {
      return l10n.time_ago_just_now;
    }
  }

  /// Formats the time to 12-hour format, showing minutes and AM/PM only (no seconds).
  String to12HourTime() => DateFormat('h:mm a', Intl.getCurrentLocale()).format(toLocal());

  /// Formats the full date-time to show the date and 12-hour time with minutes only.
  String to12HourDateTime() => DateFormat('yyyy-MM-dd h:mm a', Intl.getCurrentLocale())
        .format(toLocal());
}

extension StringDateTimeExtension on String {
  /// Parses the string as a UTC DateTime and converts it to local device time.
  /// If the string has no timezone offset, it is assumed to be UTC.
  DateTime? toLocalDateTime() {
    final clean = trim();
    if (clean.isEmpty) return null;

    final parsed = DateTime.tryParse(clean);
    if (parsed == null) return null;

    // Check if the string already contains a timezone indicator (Z or +/- offset)
    final hasTimezone =
        RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false).hasMatch(clean);

    if (hasTimezone) return parsed.toLocal();

    // If no timezone is present, the user explicitly stated backend dates are UTC.
    // We treat the components as UTC then convert to local.
    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    ).toLocal();
  }

  /// Parses the string (as a full DateTime or a Time-only string) and formats
  /// the time part in a 12-hour format with minutes only, no seconds.
  String to12HourFormat() {
    final localDateTime = toLocalDateTime();
    if (localDateTime != null) {
      return DateFormat('yyyy-MM-dd h:mm a', Intl.getCurrentLocale())
          .format(localDateTime);
    }

    // Fallback for time-only strings (e.g. "15:30") which are usually local-agnostic
    final cleanTime = trim();
    if (cleanTime.isEmpty) return this;

    final isAmPm = cleanTime.toLowerCase().contains('am') ||
        cleanTime.toLowerCase().contains('pm') ||
        cleanTime.contains('ص') ||
        cleanTime.contains('م');

    final spaceParts = cleanTime.split(RegExp(r'\s+'));
    final timePart = spaceParts[0];

    final parts = timePart.split(':');
    if (parts.isNotEmpty) {
      var hour = int.tryParse(parts[0]);
      if (hour != null && hour >= 0 && hour <= 24) {
        final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

        if (isAmPm && spaceParts.length > 1) {
          final period = spaceParts[1].toLowerCase();
          if ((period.contains('pm') || period.contains('م')) && hour < 12) {
            hour = hour + 12;
          } else if ((period.contains('am') || period.contains('ص')) &&
              hour == 12) {
            hour = 0;
          }
        }

        final now = DateTime.now();
        final dummyDateTime =
            DateTime(now.year, now.month, now.day, hour, minute);
        return DateFormat('h:mm a', Intl.getCurrentLocale())
            .format(dummyDateTime);
      }
    }

    return this;
  }

  /// Extracts the date only (e.g. "2026-05-18") converted to local time.
  String toDateOnly() {
    final localDateTime = toLocalDateTime();
    if (localDateTime != null) {
      return DateFormat('yyyy-MM-dd').format(localDateTime);
    }

    // Fallback for simple date strings
    final parts = trim().split(RegExp(r'[T\s]'));
    if (parts.isNotEmpty && parts[0].contains('-')) {
      return parts[0];
    }
    return this;
  }

  /// Extracts the time only in 12-hour format, minutes only (e.g. "12:06 PM" or "12:06 م")
  String to12HourTimeOnly() {
    final localDateTime = toLocalDateTime();
    if (localDateTime != null) {
      return DateFormat('h:mm a', Intl.getCurrentLocale())
          .format(localDateTime);
    }
    return to12HourFormat();
  }
}
