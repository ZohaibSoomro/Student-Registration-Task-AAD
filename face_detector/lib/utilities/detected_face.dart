class DetectedFace {
  List<double> anglesOfRotation;
  double smilingProbability;
  double leftEyeOpenProbability;
  double rightEyeOpenProbability;
  String capturedImagePath;

  DetectedFace({
    required this.anglesOfRotation,
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.smilingProbability,
    required this.capturedImagePath,
  });
}
