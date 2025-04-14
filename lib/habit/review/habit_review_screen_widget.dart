// lib/habit/review/habit_review_screen_widget.dart
import 'dart:io';
import 'dart:typed_data'; // Required for Uint8List
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:prabit_design/flutter_flow/flutter_flow_theme.dart'; // Adjust import
import 'package:prabit_design/flutter_flow/flutter_flow_widgets.dart'; // For FFButtonWidget
import 'package:prabit_design/flutter_flow/flutter_flow_icon_button.dart'; // For IconButton
import '../../photo/post_screen/post_screen_widget.dart'; // Target screen

class HabitReviewScreenWidget extends StatefulWidget {
  // --- Define Route Name ---
  static const String routeName = 'HabitReviewScreen';
  static const String routePath = '/habitReviewScreen';

  // --- Input Parameters ---
  final String rearImagePath;
  final String frontImagePath;
  final Map<String, dynamic> habit; // Pass habit data through

  const HabitReviewScreenWidget({
    Key? key,
    required this.rearImagePath,
    required this.frontImagePath,
    required this.habit,
  }) : super(key: key);

  @override
  _HabitReviewScreenWidgetState createState() =>
      _HabitReviewScreenWidgetState();
}

class _HabitReviewScreenWidgetState extends State<HabitReviewScreenWidget> {
  Offset _overlayPosition = const Offset(15, 15); // Initial padding top-left
  bool _isSwapped = false; // Track if front/rear are swapped
  bool _isLoading = false; // For progress indicator on proceed

  // Store image dimensions once loaded for accurate positioning
  Size _backgroundSize = Size.zero;
  Size _overlaySize = Size.zero; // Size of the overlay *widget*
  final GlobalKey _stackKey = GlobalKey(); // To get Stack size

  // Helper to get image dimensions without loading full image into memory yet
  Future<Size> _getImageDimensions(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return Size.zero;
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        return Size(image.width.toDouble(), image.height.toDouble());
      }
    } catch (e) {
      print("Error getting image dimensions for $path: $e");
    }
    return Size.zero; // Default or error case
  }

  @override
  void initState() {
    super.initState();
    // Get initial image dimensions (optional, could also do in build)
    _getImageDimensions(widget.rearImagePath).then((size) {
      if (mounted) setState(() => _backgroundSize = size);
    });
  }


  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // Determine which path is currently background/overlay
    final String currentBackgroundPath = _isSwapped ? widget.frontImagePath : widget.rearImagePath;
    final String currentOverlayPath = _isSwapped ? widget.rearImagePath : widget.frontImagePath;

    return Scaffold(
      backgroundColor: theme.primary, // Dark background
      appBar: AppBar(
        backgroundColor: theme.primary,
        elevation: 0,
        title: Text(
          'Review Photo',
          style: theme.headlineMedium.override(
              fontFamily: 'Inter Tight', color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        // We handle back navigation via the Retake button now
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            // Use LayoutBuilder to get the available size for the Stack
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the display size constraints
                final double availableWidth = constraints.maxWidth - 32; // Account for padding
                final double availableHeight = constraints.maxHeight - 32; // Account for padding

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1.0, // Keep it square for simplicity
                      child: Container(
                        key: _stackKey,
                        decoration: BoxDecoration(
                          color: theme.secondary, // Placeholder background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            // --- Background Image ---
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.file(
                                  File(currentBackgroundPath),
                                  key: ValueKey(currentBackgroundPath), // Change key on swap
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Center(child: Icon(Icons.error, color: Colors.red)),
                                  // Optional: Listener to get rendered image size if needed later
                                  // frameBuilder: (context, child, frame, wasSyncLoaded) {
                                  //    WidgetsBinding.instance.addPostFrameCallback((_) {
                                  //       // Logic to get size after render
                                  //    });
                                  //    return child;
                                  // },
                                ),
                              ),
                            ),

                            // --- Draggable Overlay Image ---
                            Builder( // Use builder to access Stack's context/size if needed later
                                builder: (context) {
                                  // Calculate overlay widget size (e.g., 1/4 of stack width)
                                  final RenderBox? stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
                                  final double stackWidth = stackBox?.size.width ?? availableWidth / 1.0; // Fallback approx
                                  final double overlayWidgetSize = stackWidth / 4.0;
                                  _overlaySize = Size(overlayWidgetSize, overlayWidgetSize); // Store widget size

                                  // Clamp position to stay within bounds
                                  double clampedX = _overlayPosition.dx.clamp(0.0, (stackBox?.size.width ?? double.infinity) - overlayWidgetSize);
                                  double clampedY = _overlayPosition.dy.clamp(0.0, (stackBox?.size.height ?? double.infinity) - overlayWidgetSize);
                                  Offset clampedPosition = Offset(clampedX, clampedY);


                                  return Positioned(
                                    left: clampedPosition.dx,
                                    top: clampedPosition.dy,
                                    width: overlayWidgetSize,
                                    height: overlayWidgetSize, // Keep overlay square
                                    child: GestureDetector(
                                      onPanUpdate: (details) {
                                        setState(() {
                                          // Update position based on drag delta
                                          _overlayPosition = Offset(
                                            _overlayPosition.dx + details.delta.dx,
                                            _overlayPosition.dy + details.delta.dy,
                                          );
                                          // Clamping happens above before setting Positioned top/left
                                        });
                                      },
                                      child: ClipRRect( // Clip overlay to rounded corners
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container( // Add border to overlay
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white, width: 1.5),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Image.file(
                                            File(currentOverlayPath),
                                            key: ValueKey(currentOverlayPath), // Change key on swap
                                            fit: BoxFit.cover, // Cover ensures it fills the square/border
                                            errorBuilder: (ctx, err, st) => Center(child: Icon(Icons.error, color: Colors.red)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Action Buttons ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // --- Retake Button ---
                FlutterFlowIconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 28),
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  onPressed: () {
                    // Navigate back to the photo screen to retake
                    if (context.canPop()) {
                      context.pop(true); // Pass 'true' to indicate retake requested
                    }
                  },
                ),

                // --- Swap Button ---
                FlutterFlowIconButton(
                  icon: Icon(Icons.swap_horiz, color: Colors.white, size: 28),
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  onPressed: () {
                    setState(() {
                      _isSwapped = !_isSwapped;
                      // Optional: Reset position on swap? Or keep it?
                      // _overlayPosition = Offset(15, 15);
                    });
                  },
                ),

                // --- Proceed Button ---
                FlutterFlowIconButton(
                  icon: _isLoading
                      ? Container(width: 24, height: 24, padding: EdgeInsets.all(2.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 32), // Use green check
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  onPressed: _isLoading ? null : _performFinalMergeAndNavigate, // Disable while loading
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Merging and Navigation Logic ---
  Future<void> _performFinalMergeAndNavigate() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Determine final paths based on swap state
      final String finalBackgroundPath = _isSwapped ? widget.frontImagePath : widget.rearImagePath;
      final String finalOverlayPath = _isSwapped ? widget.rearImagePath : widget.frontImagePath;

      // Read bytes
      final Uint8List backgroundBytes = await File(finalBackgroundPath).readAsBytes();
      final Uint8List overlayBytes = await File(finalOverlayPath).readAsBytes();

      // Decode
      img.Image? backgroundImage = img.decodeImage(backgroundBytes);
      img.Image? overlayImage = img.decodeImage(overlayBytes);

      if (backgroundImage == null || overlayImage == null) {
        throw Exception("Failed to decode images for final merge.");
      }
      print("Final merge: Images decoded.");

      // --- Calculate Final Position ---
      // Get the actual size of the background image
      final backgroundWidth = backgroundImage.width;
      final backgroundHeight = backgroundImage.height;

      // Get the display size of the stack (where dragging occurred)
      final RenderBox? stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
      final double stackWidth = stackBox?.size.width ?? backgroundWidth.toDouble(); // Fallback to image width
      final double stackHeight = stackBox?.size.height ?? backgroundHeight.toDouble(); // Fallback to image height

      // Calculate the scaling factor between display size and actual image size
      // Assume background image is scaled to fit the stack width (adjust if using contain)
      final double scaleX = backgroundWidth / stackWidth;
      final double scaleY = backgroundHeight / stackHeight;

      // Scale the overlay's screen position (_overlayPosition) to image coordinates
      // Also clamp to ensure it's within the image bounds
      final double overlayTargetX = (_overlayPosition.dx * scaleX);
      final double overlayTargetY = (_overlayPosition.dy * scaleY);

      // Resize overlay image relative to the background image size (e.g., 1/4 width)
      int overlayTargetWidth = backgroundWidth ~/ 4;
      img.Image resizedOverlay = img.copyResize(overlayImage, width: overlayTargetWidth);

      // Clamp position based on *image* dimensions and *resized overlay* dimensions
      final int finalX = overlayTargetX.clamp(0, backgroundWidth - resizedOverlay.width).toInt();
      final int finalY = overlayTargetY.clamp(0, backgroundHeight - resizedOverlay.height).toInt();

      print("Final merge: Overlay pos (image coords): ($finalX, $finalY), Overlay size: ${resizedOverlay.width}x${resizedOverlay.height}");


      // --- Perform Merge ---
      img.compositeImage(
        backgroundImage, // Destination
        resizedOverlay, // Source
        dstX: finalX,
        dstY: finalY,
      );
      print("Final merge: Composite complete.");


      // --- Save Final Image ---
      final tempDir = await getTemporaryDirectory();
      final finalFilePath = '${tempDir.path}/final_merged_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final finalFile = File(finalFilePath);
      await finalFile.writeAsBytes(img.encodeJpg(backgroundImage, quality: 90)); // Use good quality
      print('Final merged image saved to: $finalFilePath');

      // --- Navigate ---
      if (mounted) {
        context.pushNamed(
          HabitPostScreenWidget.routeName,
          extra: {
            'habit': widget.habit,
            'imageUrl': finalFilePath, // Pass the *final* merged image path
          },
        );
      }
    } catch (e) {
      print("🚨 Error during final merge/navigation: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating final image: ${e.toString()}'))
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}