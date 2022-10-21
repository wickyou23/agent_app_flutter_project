import 'package:agent_app/app/app_config.dart';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  static String keyName = '/camera';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.pausePreview();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.resumePreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller == null) Container() else CameraPreview(_controller!),
          Positioned(
            top: 30,
            left: 0,
            child: IconButton(
              onPressed: () {
                context.navigator.pop();
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initializeCamera() {
    if (AppConfig.cameras.isEmpty) {
      logger.e("Device's cameras not avalible");
      return;
    }

    _controller = CameraController(AppConfig.cameras[0], ResolutionPreset.max);
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            logger.e('User denied camera access.');
            break;
          default:
            logger.e('Handle other errors.');
            break;
        }
      }
    });
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final oldController = _controller;
    if (oldController != null) {
      _controller = null;
      await oldController.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    _controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }
      // if (cameraController.value.hasError) {
      //   showInSnackBar(
      //       'Camera error ${cameraController.value.errorDescription}');
      // }
    });

    try {
      await _controller?.initialize();
      // await Future.wait(<Future<Object?>>[
      //   // The exposure mode is currently not supported on the web.
      //   ...!kIsWeb
      //       ? <Future<Object?>>[
      //           cameraController.getMinExposureOffset().then(
      //               (double value) => _minAvailableExposureOffset = value),
      //           cameraController
      //               .getMaxExposureOffset()
      //               .then((double value) => _maxAvailableExposureOffset = value)
      //         ]
      //       : <Future<Object?>>[],
      //   cameraController
      //       .getMaxZoomLevel()
      //       .then((double value) => _maxAvailableZoom = value),
      //   cameraController
      //       .getMinZoomLevel()
      //       .then((double value) => _minAvailableZoom = value),
      // ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          logger.e('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          logger.e('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          logger.e('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          logger.e('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          logger.e('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          logger.e('Audio access is restricted.');
          break;
        default:
          logger.e(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }
}
