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
  });

  final String course;
  final String title;
  final CampusPlace building;
  final String room;
  final TimeOfDay start;
}

const nextClass = ClassMeeting(
  course: 'CSE 110',
  title: 'Software Engineering',
  building: CampusPlaces.centerHall,
  room: '105',
  start: TimeOfDay(hour: 9, minute: 30),
);
