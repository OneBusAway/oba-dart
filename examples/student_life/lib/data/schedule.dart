import 'package:flutter/material.dart' show TimeOfDay;

import 'campus.dart';

/// One class meeting from the student's (mock) schedule.
class ClassMeeting {
  const ClassMeeting({
    required this.course,
    required this.title,
    required this.building,
    required this.room,
    required this.start,
    required this.walkMinutes,
  });

  final String course;
  final String title;
  final CampusPlace building;
  final String room;
  final TimeOfDay start;

  /// Walking time from the student's usual spot, from the host's own data.
  final int walkMinutes;

  /// When to leave to arrive five minutes early.
  TimeOfDay get leaveBy {
    final minutes = start.hour * 60 + start.minute - walkMinutes - 5;
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }
}

const nextClass = ClassMeeting(
  course: 'CSE 110',
  title: 'Software Engineering',
  building: CampusPlaces.centerHall,
  room: '105',
  start: TimeOfDay(hour: 9, minute: 30),
  walkMinutes: 13,
);
