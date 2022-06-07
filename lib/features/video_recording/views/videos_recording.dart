import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/video_recording_bloc.dart';
import '../bloc/video_recording_events.dart';

late List<CameraDescription> _cameras;

class VideoRecording extends StatefulWidget {
  const VideoRecording({Key? key}) : super(key: key);

  @override
  State<VideoRecording> createState() => _VideoRecordingState();
}

class _VideoRecordingState extends State<VideoRecording> {
  late VideoRecordingBloc _bloc;
  late CameraController controller;
  bool _cameraInitialized = false;
  bool _cameraIsRecording = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getCameras() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
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
    _bloc = context.read<VideoRecordingBloc>();
    _getCameras();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
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

      await file.saveTo(filePath);
      _bloc.add(VideoRecordingEventsAddVideo(filePath));
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idea reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Idea reminder'),
          ),
        ),
        body: Builder(
          builder: (context) {
            if (!_cameraInitialized) {
              return const Text('Loading...');
            }
            return _mainWidget();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Home',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Record',
              backgroundColor: Colors.blueGrey,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/record');
                break;
              default:
                context.go('/');
            }

            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}
