import 'package:intl/intl.dart';

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

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get toIso8601DateOnly {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  /// Formats the time to 12-hour format, showing minutes and AM/PM only (no seconds).
  String to12HourTime() {
    return DateFormat('h:mm a', Intl.getCurrentLocale()).format(this);
  }

  /// Formats the full date-time to show the date and 12-hour time with minutes only.
  String to12HourDateTime() {
    return DateFormat('yyyy-MM-dd h:mm a', Intl.getCurrentLocale())
        .format(this);
  }
}

extension StringDateTimeExtension on String {
  /// Parses the string (as a full DateTime or a Time-only string) and formats
  /// the time part in a 12-hour format with minutes only, no seconds.
  String to12HourFormat() {
    if (trim().isEmpty) return this;

    // 1. Try to parse as full ISO/SQL DateTime (e.g. "2026-05-18T12:06:30Z" or "2026-05-18 12:06:30")
    final parsedDateTime = DateTime.tryParse(trim());
    if (parsedDateTime != null) {
      // Convert to local time to display correct timezone
      final localDateTime = parsedDateTime.toLocal();
      return DateFormat('yyyy-MM-dd h:mm a', Intl.getCurrentLocale())
          .format(localDateTime);
    }

    // 2. Try to parse as a time-only string (e.g., "15:30:45", "15:30", "03:30:00 PM")
    // Let's strip any existing AM/PM to avoid parsing issues and parse the core time
    final String cleanTime = trim();
    final bool isAmPm = cleanTime.toLowerCase().contains('am') ||
        cleanTime.toLowerCase().contains('pm') ||
        cleanTime.contains('ص') ||
        cleanTime.contains('م');

    // Split by spaces to find the time part and period part if present
    final spaceParts = cleanTime.split(RegExp(r'\s+'));
    final String timePart = spaceParts[0];

    // Split by ':' to parse hours and minutes
    final parts = timePart.split(':');
    if (parts.isNotEmpty) {
      int? hour = int.tryParse(parts[0]);
      if (hour != null && hour >= 0 && hour <= 24) {
        final int minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

        // Handle AM/PM period if it was already formatted but needs standardizing
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

  /// Extracts the date only (e.g. "2026-05-18")
  String toDateOnly() {
    if (trim().isEmpty) return this;
    final parsedDateTime = DateTime.tryParse(trim());
    if (parsedDateTime != null) {
      final localDateTime = parsedDateTime.toLocal();
      return DateFormat('yyyy-MM-dd').format(localDateTime);
    }
    final parts = trim().split(RegExp(r'[T\s]'));
    if (parts.isNotEmpty && parts[0].contains('-')) {
      return parts[0];
    }
    return this;
  }

  /// Extracts the time only in 12-hour format, minutes only (e.g. "12:06 PM" or "12:06 م")
  String to12HourTimeOnly() {
    if (trim().isEmpty) return this;
    final parsedDateTime = DateTime.tryParse(trim());
    if (parsedDateTime != null) {
      final localDateTime = parsedDateTime.toLocal();
      return DateFormat('h:mm a', Intl.getCurrentLocale())
          .format(localDateTime);
    }
    return to12HourFormat();
  }
}
