import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> _cameras;

class VideoRecording extends StatefulWidget {
  const VideoRecording({Key? key}) : super(key: key);

  @override
  State<VideoRecording> createState() => _VideoRecordingState();
}

class _VideoRecordingState extends State<VideoRecording> {
  late CameraController controller;

  bool _cameraInitialized = false;
  bool _cameraIsRecording = false;

  Future<void> _getCameras() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        //!controller.value.isInitialized
        _cameraInitialized = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCameras();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // onNewCameraSelected(cameraController.description);
    }
  }

  Future<void> _startVideoRecording() async {
    print('controller.value.isRecordingVideo');
    print(controller.value.isRecordingVideo);
    if (!controller.value.isInitialized) {
      return;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return;
    }

    try {
      await controller.startVideoRecording();
      setState(() {
        _cameraIsRecording = true;
      });
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _stopVideoRecording() async {
    print('stop!');
    print(controller.value.isRecordingVideo);
    if (!_cameraIsRecording) {
      return null;
    }

    try {
      final file = await controller.stopVideoRecording();
      setState(() {
        _cameraIsRecording = false;
      });

      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String videoDirectory = '${appDirectory.path}/Videos';
      await Directory(videoDirectory).create(recursive: true);
      final String currentTime =
          DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '$videoDirectory/${currentTime}.mp4';

      print('filePath');
      print(filePath);
      print(file.saveTo(filePath));
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Widget _mainWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: controller != null && _cameraIsRecording
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _captureControlRowWidget(),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.videocam),
              color: Colors.blue,
              onPressed: (_cameraInitialized && !_cameraIsRecording)
                  ? _startVideoRecording
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              color: Colors.red,
              onPressed: (_cameraInitialized && _cameraIsRecording)
                  ? _stopVideoRecording
                  : null,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraInitialized) {
      return Container(
        child: Text('lol'),
      );
    }
    print('ooi');
    return _mainWidget();
  }
}
