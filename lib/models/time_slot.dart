import 'package:flutter/material.dart';

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeSlot(this.startTime, this.endTime);

  bool overlaps(TimeSlot other) {
    final start1 = _timeToMinutes(startTime);
    final end1 = _timeToMinutes(endTime);
    final start2 = _timeToMinutes(other.startTime);
    final end2 = _timeToMinutes(other.endTime);

    return (start1 < end2 && start2 < end1); // Check for overlap
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
