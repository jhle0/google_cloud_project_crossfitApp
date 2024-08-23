import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'calculate_angle.dart';
import 'coordinates_translator.dart';


class PosePainter extends CustomPainter {
  PosePainter(
      this.poses,
      this.imageSize,
      this.rotation,
      this.cameraLensDirection
      );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            1,
            paint);
      });
      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      void drawAngle(
          PoseLandmarkType joint1Type,
          PoseLandmarkType joint2Type,
          PoseLandmarkType joint3Type,
          Canvas canvas,
          Size size,
          Size imageSize,
          InputImageRotation rotation,
          CameraLensDirection cameraLensDirection) {
        final joint1 = pose.landmarks[joint1Type];
        final joint2 = pose.landmarks[joint2Type];
        final joint3 = pose.landmarks[joint3Type];
        if (joint1 != null && joint2 != null && joint3 != null) {
          final angle = calculateAngle(joint1, joint2, joint3);

          const textStyle = TextStyle(
              color: Color(0xff000000),
              fontSize: 16.0,
              backgroundColor: Color(0xFFFFFFFF)
          );

          final textSpan = TextSpan(
            text: '${angle.toStringAsFixed(2)}°',
            style: textStyle,
          );

          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout(minWidth: 0, maxWidth: size.width);

          final textOffset = Offset(
            translateX(joint2.x, size, imageSize, rotation, cameraLensDirection) + 10,
            translateY(joint2.y, size, imageSize, rotation, cameraLensDirection) - 25,
          );

          final textSize = textPainter.size;
          final backgroundRect = Rect.fromLTWH(
            textOffset.dx - 5,
            textOffset.dy - 5,
            textSize.width + 10,
            textSize.height + 10,
          );

          // 배경 그리기
          final backgroundPaint = Paint()..color = Colors.white.withOpacity(0.8);
          canvas.drawRect(backgroundRect, backgroundPaint);

          // 텍스트 그리기
          textPainter.paint(canvas, textOffset);
        }
      }

      //Draw arms
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      // Draw angles (Air Squat: 각도 12개, 2개 더 해야됨.)
      drawAngle(PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex, canvas, size, imageSize, rotation, cameraLensDirection);

      drawAngle(PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, canvas, size, imageSize, rotation, cameraLensDirection);
      drawAngle(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex, canvas, size, imageSize, rotation, cameraLensDirection);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}