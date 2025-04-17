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
            (camera) => camera.lensDirection == CameraLensDirection.back  ,
        orElse: () {
          print("Warning: No front camera found, using rear camera for both.");
          return cameras!.first; // Fallback to first camera if no specific back camera
        }
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

  // In lib/habit/photo/habit_photo_screen_widget.dart

  // In lib/habit/photo/habit_photo_screen_widget.dart


// --- Add this method inside your _HabitPhotoScreenWidgetState class ---

  Future<void> _capturePhotos() async {
    // Initial checks for readiness (include front controller check here now)
    if (_isCapturing ||
        !_camerasInitialized ||
        _frontController == null || // Need front controller first
        !_frontController!.value.isInitialized ||
        _rearController == null ||  // Also ensure rear controller is available
        !_rearController!.value.isInitialized)
    {
      print("Capture conditions not met (capturing: $_isCapturing, initialized: $_camerasInitialized, front ready: ${_frontController?.value.isInitialized}, rear ready: ${_rearController?.value.isInitialized})");
      if (!_camerasInitialized && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera not ready.')));
      }
      if (_isCapturing && mounted) setState(() => _isCapturing = false); // Reset if needed
      return;
    }

    setState(() { _isCapturing = true; });
    print("Starting photo capture sequence (FRONT first)...");

    // Clear previous temporary file references
    _rearImageFile = null;
    _frontImageFile = null;
    String? persistentFrontPath; // Paths for successfully saved persistent files
    String? persistentRearPath;
    bool frontSaveOk = false; // Track individual save success
    bool rearSaveOk = false;

    try {
      // --- 1. Capture Front Photo ---
      print(">>> CAPTURE DEBUG: Attempting to take picture with FRONT controller (ID: ${_frontController?.description.name})");
      _frontImageFile = await _frontController!.takePicture();
      print(">>> POST CAPTURE CHECK: Front file is ${_frontImageFile == null ? 'NULL' : 'VALID'}. Path: ${_frontImageFile?.path}");

      // --- 2. Save Front Photo Persistently ---
      if (_frontImageFile != null) {
        try {
          final Directory docsDir = await getApplicationDocumentsDirectory();
          final String docsDirPath = docsDir.path;
          final timestamp = DateTime.now().millisecondsSinceEpoch; // Use separate timestamps now
          final String sourceFrontPath = _frontImageFile!.path;
          persistentFrontPath = '$docsDirPath/X_habit_front_$timestamp.jpg'; // Define persistent path

          print("Attempting to save FRONT original:");
          print("  Source (temp): $sourceFrontPath");
          print("  Destination (persistent): $persistentFrontPath");

          final sourceFrontFile = File(sourceFrontPath);
          if (await sourceFrontFile.exists()) {
            print("  Source front file exists, attempting copy...");
            await sourceFrontFile.copy(persistentFrontPath!);
            if (await File(persistentFrontPath).exists()) {
              print("  SUCCESS: Saved persistent front photo to: $persistentFrontPath");
              frontSaveOk = true;
            } else { print("  ERROR: Destination front file does NOT exist after copy attempt!"); }
          } else { print("  ERROR: Source front file does NOT exist before copy!"); }
        } catch(e) {
          print("🚨 Error saving persistent FRONT original: $e");
          // frontSaveOk remains false
        }
      } else {
        print("Skipping front save because capture result was null.");
      }

      // --- 3. Capture Rear Photo ---
      // Proceed only if front capture was obtained (even if save failed, maybe still try rear?)
      // Let's proceed to capture rear even if front save failed, but navigation will depend on both saves.
      if (_frontImageFile != null) { // Check if front *capture* was successful
        await Future.delayed(const Duration(milliseconds: 100)); // Brief pause

        print(">>> CAPTURE DEBUG: Attempting to take picture with REAR controller (ID: ${_rearController?.description.name})");
        _rearImageFile = await _rearController!.takePicture();
        print(">>> POST CAPTURE CHECK: Rear file is ${_rearImageFile == null ? 'NULL' : 'VALID'}. Path: ${_rearImageFile?.path}");

        // --- 4. Save Rear Photo Persistently ---
        if (_rearImageFile != null) {
          try {
            final Directory docsDir = await getApplicationDocumentsDirectory();
            final String docsDirPath = docsDir.path;
            final timestamp = DateTime.now().millisecondsSinceEpoch; // Separate timestamp
            final String sourceRearPath = _rearImageFile!.path;
            persistentRearPath = '$docsDirPath/X_habit_rear_$timestamp.jpg'; // Define persistent path

            print("Attempting to save REAR original:");
            print("  Source (temp): $sourceRearPath");
            print("  Destination (persistent): $persistentRearPath");

            final sourceRearFile = File(sourceRearPath);
            if (await sourceRearFile.exists()) {
              print("  Source rear file exists, attempting copy...");
              await sourceRearFile.copy(persistentRearPath!);
              if (await File(persistentRearPath).exists()) {
                print("  SUCCESS: Saved persistent rear photo to: $persistentRearPath");
                rearSaveOk = true;
              } else { print("  ERROR: Destination rear file does NOT exist after copy attempt!"); }
            } else { print("  ERROR: Source rear file does NOT exist before copy!"); }
          } catch (e) {
            print("🚨 Error saving persistent REAR original: $e");
            // rearSaveOk remains false
          }
        } else {
          print("Skipping rear save because capture result was null.");
        }
      } else {
        print("Skipping rear capture because front capture failed.");
      }


      // --- 5. Navigate only if BOTH saves were successful ---
      if (rearSaveOk && frontSaveOk && persistentRearPath != null && persistentFrontPath != null) {
        print("Both originals captured and saved persistently, proceeding to Review Screen.");
        if (mounted) {
          final result = await context.pushNamed<bool>(
            HabitReviewScreenWidget.routeName,
            extra: {
              // Pass the persistent paths
              'rearImagePath': persistentRearPath,
              'frontImagePath': persistentFrontPath,
              'habit': widget.habit,
            },
          );
          // Handle retake result
          if (result == true && mounted) {
            print("Retake requested from Review Screen. Resetting capture state.");
            setState(() { _rearImageFile = null; _frontImageFile = null; _isCapturing = false; _countdownValue = 5; });
            _startCountdown();
          } else if (mounted) {
            print("Review screen finished/popped.");
            if (context.canPop()) context.pop();
            setState(() => _isCapturing = false);
          }
        } else {
          // mounted is false after await
          _isCapturing = false;
        }
      } else {
        // If one or both saves failed or captures failed
        print("Error: Capture or save process incomplete. Front Save OK: $frontSaveOk, Rear Save OK: $rearSaveOk");
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error capturing or saving photos.')));
          setState(() { _isCapturing = false; }); // Allow retry
        }
      }

    } on CameraException catch (e) {
      print('CameraException during capture: ${e.code} - ${e.description}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera error: ${e.description ?? e.code}')));
        setState(() { _isCapturing = false; });
      }
    } catch (e) {
      print('Unexpected error during photo capture process: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')));
        setState(() { _isCapturing = false; });
      }
    } finally {
      // Ensure capturing state is reset if it's still true and we are mounted
      // (Should be handled by specific paths, but as a safeguard)
      if (mounted && _isCapturing) {
        print("Capture process finished (finally block). Resetting capturing state if needed.");
        // setState(() => _isCapturing = false); // Let specific paths handle it now
      }
    }
  } // End _capturePhotos


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