// lib/habit/photo/habit_photo_screen_widget.dart
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img; // Use prefix to avoid conflicts
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prabit_design/flutter_flow/flutter_flow_theme.dart'; // Adjust import if needed

// Import the post screen route name (adjust path if needed)
import '../../photo/post_screen/post_screen_widget.dart';
import '../review/habit_review_screen_widget.dart'; // Make sure this is the correct post screen


class HabitPhotoScreenWidget extends StatefulWidget {
  // Define route name for GoRouter
  static const String routeName = 'HabitPhotoScreen';
  static const String routePath = '/habitPhotoScreen'; // Match path in nav.dart


  final Map<String, dynamic> habit; // Receive habit data

  const HabitPhotoScreenWidget({Key? key, required this.habit}) : super(key: key);

  @override
  _HabitPhotoScreenWidgetState createState() => _HabitPhotoScreenWidgetState();
}

class _HabitPhotoScreenWidgetState extends State<HabitPhotoScreenWidget> with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _rearController;
  CameraController? _frontController;
  List<CameraDescription>? cameras;
  bool _camerasInitialized = false;
  Timer? _countdownTimer;
  int _countdownValue = 5; // Start countdown from 5 seconds
  bool _isCapturing = false;
  XFile? _rearImageFile;
  XFile? _frontImageFile;

  late AnimationController _animationController;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // Make the number pulse

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print('No cameras available');
        // Handle error: show message to user, maybe pop screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: No cameras found on this device.'))
          );
          context.pop(); // Go back if no cameras
        }
        return;
      }

      // Find rear camera
      final rearCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first, // Fallback to first camera if no specific back camera
      );

      // Find front camera
      final frontCamera = cameras!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () {
            print("Warning: No front camera found, using rear camera for both.");
            return rearCamera; // Fallback if no front camera
          }
      );

      // --- ADD THESE PRINT STATEMENTS ---
      print(">>> DEBUG: Rear Camera Found: Name='${rearCamera.name}', LensDirection='${rearCamera.lensDirection}'");
      print(">>> DEBUG: Front Camera Found: Name='${frontCamera.name}', LensDirection='${frontCamera.lensDirection}'");
      // --- END PRINT STATEMENTS ---

      _rearController = CameraController(
        rearCamera,
        ResolutionPreset.high, // Or choose preset as needed
        enableAudio: false, // No audio needed for photos
        imageFormatGroup: ImageFormatGroup.jpeg, // Or yuv420 for faster preview
      );

      _frontController = CameraController(
        frontCamera,
        ResolutionPreset.medium, // Maybe lower res for front
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize controllers one after another
      await _rearController!.initialize();
      if (frontCamera != rearCamera) { // Only initialize front if it's different
        await _frontController!.initialize();
      } else {
        _frontController = null; // Ensure front controller is null if using rear for both
        print("Using rear camera for 'front' picture as well.");
      }


      if (!mounted) return;

      setState(() {
        _camerasInitialized = true;
      });
      _startCountdown(); // Start countdown after initialization

    } on CameraException catch (e) {
      print('Error initializing camera: $e');
      // Handle error: show message, pop screen etc.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error initializing camera: ${e.description}'))
        );
        context.pop(); // Go back on error
      }
    } catch (e) {
      print('Unexpected error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred while accessing the camera.'))
        );
        context.pop(); // Go back on error
      }
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownValue = 5; // Reset countdown
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownValue > 1) {
        if (mounted) {
          setState(() {
            _countdownValue--;
          });
          _animationController.forward(from: 0.0); // Trigger pulse animation
        }
      } else {
        timer.cancel();
        _animationController.stop();
        if (mounted) {
          setState(() {
            _countdownValue = 0; // Show 0 briefly or a capture indicator
          });
          _capturePhotos();
        }
      }
    });
  }


  // In lib/habit/photo/habit_photo_screen_widget.dart

  // --- TEMPORARY TEST 1: REAR ONLY ---
  Future<void> _capturePhotos() async {
    if (_isCapturing || !_camerasInitialized || _rearController == null) return;

    setState(() { _isCapturing = true; });
    print(">>> TEST 1: REAR ONLY - Starting capture...");
    _rearImageFile = null; // Clear any previous
    _frontImageFile = null;

    try {
      if (_rearController!.value.isTakingPicture) {
        print(">>> TEST 1: Rear controller busy.");
        setState(() { _isCapturing = false; }); return;
      }
      print(">>> TEST 1: Attempting REAR capture (ID: ${_rearController?.description.name})");
      _rearImageFile = await _rearController!.takePicture();
      print(">>> TEST 1: Rear capture complete. Path: ${_rearImageFile?.path}");

      if (_rearImageFile != null) {
        print(">>> TEST 1: Rear image valid. Saving for inspection.");
        // Save it with a specific name to check later
        final tempDir = await getTemporaryDirectory();
        final debugPath = '${tempDir.path}/TEST_REAR_ONLY_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(_rearImageFile!.path).copy(debugPath);
        print(">>> TEST 1: Saved rear-only test image to: $debugPath");

        // Show a success message and maybe pop back? Or navigate to review with only one image?
        // For now, just show success and allow manual closing/retrying.
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('TEST 1: Rear capture saved to $debugPath')));
        }

      } else {
        print(">>> TEST 1: Rear capture failed silently (file is null).");
        if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('TEST 1: Rear capture failed.'))); }
      }

    } catch (e) {
      print(">>> TEST 1: Error during rear capture: $e");
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('TEST 1: Error: ${e.toString()}'))); }
    } finally {
      if (mounted) {
        setState(() { _isCapturing = false; }); // Allow trying again or closing
      }
    }
  }
  // --- END TEMPORARY TEST 1 ---

  // --- Make sure _mergeAndNavigate is commented out or removed ---
  // Future<void> _mergeAndNavigate() async { ... }apturePhotos

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? rearCamController = _rearController;
    final CameraController? frontCamController = _frontController;

    // App state changed before controllers initialized.
    if (rearCamController == null || !rearCamController.value.isInitialized ||
        (frontCamController != null && !frontCamController.value.isInitialized)) {
      return;
    }

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Free up memory when camera is not active.
      rearCamController.dispose();
      frontCamController?.dispose();
      if (mounted) {
        setState(() { _camerasInitialized = false; });
      }
      _countdownTimer?.cancel(); // Stop countdown if app goes inactive
      _animationController.stop();

    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera controllers when the app resumes.
      print("App resumed, re-initializing cameras");
      _initializeCameras();
    }
    else if (state == AppLifecycleState.detached) {
      rearCamController.dispose();
      frontCamController?.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _rearController?.dispose();
    _frontController?.dispose();
    _animationController.dispose();
    print("HabitPhotoScreen disposed");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Use FlutterFlow theme for consistency
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      // Make AppBar transparent or minimal
      extendBodyBehindAppBar: true, // Allow body to fill behind app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(), // Simple back navigation
        ),
        // Optional: Add habit name to AppBar
        // title: Text(
        //   widget.habit['name'] ?? 'Take Photo',
        //   style: theme.titleMedium.override(
        //     fontFamily: theme.titleMediumFamily,
        //     color: Colors.white,
        //     useGoogleFonts: GoogleFonts.asMap().containsKey(theme.titleMediumFamily),
        //   ),
        // ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera Preview (using rear camera preview as primary)
          Positioned.fill(
            child: _camerasInitialized && _rearController != null
                ? CameraPreview(_rearController!)
                : Container(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator(color: theme.primary)),
            ),
          ),

          // Countdown Timer Overlay
          if (_countdownValue > 0 && !_isCapturing)
            Positioned.fill(
              child: Container(
                // Semi-transparent overlay during countdown? Optional.
                // color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: Text(
                      '$_countdownValue',
                      style: TextStyle(
                        fontSize: 120, // Large countdown number
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [ // Add shadow for better visibility
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.8),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Capturing Indicator
          if (_isCapturing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Dark overlay
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                            "Capturing & Processing...",
                            style: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              color: Colors.white,
                              // useGoogleFonts: GoogleFonts.asMap().containsKey(theme.bodyMediumFamily), // Check font usage
                            )
                        )
                      ],
                    )
                ),
              ),
            ),

          // Add other UI elements if needed (e.g., flip camera button if not automatic)
        ],
      ),
    );
  }
}