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
import '../../photo/post_screen/post_screen_widget.dart'; // Make sure this is the correct post screen


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


  Future<void> _capturePhotos() async {
    if (_isCapturing || !_camerasInitialized || _rearController == null) return;

    setState(() { _isCapturing = true; });
    print("Starting photo capture...");

    try {
      // --- Capture Rear Photo ---
      if (_rearController!.value.isTakingPicture) return;
      _rearImageFile = await _rearController!.takePicture();
      print('Rear photo captured: ${_rearImageFile?.path}');


      // --- Capture Front Photo ---
      if (_frontController != null && _frontController!.value.isInitialized) {
        if (_frontController!.value.isTakingPicture) {
          print("Front camera was busy, delaying slightly...");
          await Future.delayed(Duration(milliseconds: 100)); // Small delay if busy
          if (_frontController!.value.isTakingPicture) return; // Give up if still busy
        }
        _frontImageFile = await _frontController!.takePicture();
        print('Front photo captured: ${_frontImageFile?.path}');
      } else {
        // If no front controller (fallback), take another rear picture for the 'front'
        print("Taking second rear photo as front fallback");
        _rearController!.resumePreview(); // Resume preview before taking second shot
        await Future.delayed(Duration(milliseconds: 100)); // Ensure preview is back
        _frontImageFile = await _rearController!.takePicture();
        print('Fallback front photo captured: ${_frontImageFile?.path}');
      }


      if (_rearImageFile != null && _frontImageFile != null) {
        print("Both photos captured, proceeding to merge.");
        _mergeAndNavigate();
      } else {
        print("Error: One or both photos failed to capture.");
        // Handle error - maybe show a retry button?
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to capture photos. Please try again.'))
          );
          setState(() { _isCapturing = false; }); // Allow retry
        }
      }

    } on CameraException catch (e) {
      print('Error capturing photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error capturing photo: ${e.description}'))
        );
      }
      setState(() { _isCapturing = false; });
    } catch (e) {
      print('Unexpected error capturing photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred during capture.'))
        );
      }
      setState(() { _isCapturing = false; });
    }
  }

  Future<void> _mergeAndNavigate() async {
    if (_rearImageFile == null || _frontImageFile == null) return;

    try {
      // Load images using the 'image' package
      final rearBytes = await File(_rearImageFile!.path).readAsBytes();
      final frontBytes = await File(_frontImageFile!.path).readAsBytes();

      img.Image? rearImage = img.decodeImage(rearBytes);
      img.Image? frontImage = img.decodeImage(frontBytes);

      if (rearImage == null || frontImage == null) {
        print("Error decoding images.");
        // Handle error
        return;
      }

      // --- Image Merging Logic (BeReal Style) ---
      // Resize front image to be smaller (e.g., 1/4 width of rear)
      int frontWidth = rearImage.width ~/ 4;
      img.Image resizedFront = img.copyResize(frontImage, width: frontWidth);

      // Position front image (e.g., top-left corner with padding)
      int padding = rearImage.width ~/ 30; // Small padding based on rear image size

      // Merge: Draw the resized front image onto the rear image
      // Ensure coordinates are within bounds
      img.compositeImage(
        rearImage, // Destination image
        resizedFront, // Source image
        dstX: padding, // Destination X
        dstY: padding, // Destination Y
      );
      // Alternatively using drawImage which might handle transparency better if needed
      // img.drawImage(rearImage, resizedFront, dstX: padding, dstY: padding);

      // --- End Merging Logic ---

      // Get temp directory to save merged image
      final tempDir = await getTemporaryDirectory();
      final mergedFilePath = '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final mergedFile = File(mergedFilePath);

      // Encode the merged image as JPG and save
      await mergedFile.writeAsBytes(img.encodeJpg(rearImage, quality: 85)); // Adjust quality as needed
      print('Merged image saved to: $mergedFilePath');

      // --- Navigation ---
      // Navigate to the Post Screen, passing the merged image path and habit data
      if (mounted) {
        // --- CORRECTED NAVIGATION CALL ---
        print('>>> DEBUG: Navigating to ${HabitPostScreenWidget.routeName} with extra: ${{
          'habit_name': widget.habit['name'], // Print something simple from habit
          'imageUrl_length': mergedFilePath.length // Print length to confirm value
        }}'); // Optional debug print added

        context.pushNamed(
          HabitPostScreenWidget.routeName, // Target route name
          extra: { // Pass BOTH items in the 'extra' map
            'habit': widget.habit,
            'imageUrl': mergedFilePath, // Pass the file path HERE
          },
          // Ensure pathParameters is completely removed
        );
        // --- END CORRECTED NAVIGATION CALL ---
        print("Navigating to Post Screen.");
      }


    } catch (e) {
      print("Error merging or saving image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error processing image.'))
        );
        setState(() { _isCapturing = false; }); // Allow retry?
      }
    }
  }

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