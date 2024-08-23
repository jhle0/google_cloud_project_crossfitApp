import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math';

import 'package:flutter/material.dart';

double calculateAngle(
    PoseLandmark point1, PoseLandmark point2, PoseLandmark point3) {
  final radians = atan2(point3.y - point2.y, point3.x - point2.x) -
      atan2(point1.y - point2.y, point1.x - point2.x);
  var angle = radians * 180 / pi;
  if (angle > 180) {
    angle = 360 - angle;
  } else if (angle < -180) {
    angle = angle + 360;
  }

  return angle.abs();
}

double? calculateAngleWithLandmark(
    Pose pose,
    PoseLandmarkType type1,
    PoseLandmarkType type2,
    PoseLandmarkType type3,
    String bodyPartName) {
  final landmark1 = pose.landmarks[type1];
  final landmark2 = pose.landmarks[type2];
  final landmark3 = pose.landmarks[type3];

  final angle = calculateAngle(landmark1!, landmark2!, landmark3!);
  //debugPrint('$bodyPartName 각도: ${angle.toStringAsFixed(2)}');

  return angle;
}