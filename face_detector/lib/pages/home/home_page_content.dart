import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detector/utilities/detected_face.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  InputImage? imageTaken;
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  DetectedFace? _detectedFace;
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    initCameras();
  }

  initCameras() async {
    cameras = await availableCameras();

    _cameraController = CameraController(cameras.last, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cameraController == null
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: size.height * 0.7,
                width: size.width,
                child: CameraPreview(_cameraController!),
              ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: capture,
              child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.camera_alt_outlined)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
    _cameraController!.dispose();
  }

  capture() async {
    Size size = MediaQuery.of(this.context).size;
    final image = await _cameraController!.takePicture();
    imageTaken = InputImage.fromFilePath(image.path);
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    image.saveTo(path);

    showDialog(
      context: this.context,
      builder: (context) => Material(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: size.width,
          height: size.height * 0.75,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.5,
                  child: Image.file(
                    File(image.path),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: processImage(imageTaken!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText('Angles of rotation', isBold: true),
                        _buildText('X:  ${_detectedFace!.anglesOfRotation[0]}'),
                        _buildText('Y:  ${_detectedFace!.anglesOfRotation[1]}'),
                        _buildText('Z:  ${_detectedFace!.anglesOfRotation[2]}'),
                        _buildText('Feature Probabilities', isBold: true),
                        _buildText(
                            'Left eye open:  ${_detectedFace!.leftEyeOpenProbability}'),
                        _buildText(
                            'Right eye open:  ${_detectedFace!.rightEyeOpenProbability}'),
                        _buildText(
                            'Smiling:  ${_detectedFace!.smilingProbability}'),
                      ],
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_back)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    final List<Face> faces = await faceDetector.processImage(inputImage);
    // for(Face face in faces){}
    Face face = faces[0];
    final double rotY =
        face.headEulerAngleY!; // Head is rotated to the right rotY degrees
    final double rotX =
        face.headEulerAngleX!; // Head is rotated to the right rotY degrees
    final double rotZ =
        face.headEulerAngleZ!; // Head is tilted sideways rotZ degrees
    final anglesOfRotation = [rotX, rotY, rotZ];
    double smilingProbability = face.smilingProbability!;
    double leftEyeOpenProbability = face.leftEyeOpenProbability!;
    double rightEyeOpenProbability = face.rightEyeOpenProbability!;
    String capturedImagePath = inputImage.filePath!;

    setState(() {
      _detectedFace = DetectedFace(
        anglesOfRotation: anglesOfRotation,
        leftEyeOpenProbability: leftEyeOpenProbability,
        rightEyeOpenProbability: rightEyeOpenProbability,
        smilingProbability: smilingProbability,
        capturedImagePath: capturedImagePath,
      );
    });
  }
}
