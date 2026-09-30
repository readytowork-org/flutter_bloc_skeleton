import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:no_screenshot/overlay_mode.dart';
import 'package:no_screenshot/secure_widget.dart';
import 'package:no_screenshot/screenshot_snapshot.dart';

import '../../../../core/security/screen_record_block.dart';

class RecordingGuard extends StatefulWidget {
  final Widget child;
  final OverlayMode mode;
  final double blurRadius;

  const RecordingGuard({
    super.key,
    required this.child,
    this.mode = OverlayMode.secure,
    this.blurRadius = 100.0,
  });

  @override
  State<RecordingGuard> createState() => _RecordingGuardState();
}

class _RecordingGuardState extends State<RecordingGuard> {
  final _noScreenshot = NoScreenshot.instance;
  StreamSubscription<ScreenshotSnapshot>? _streamSubscription;
  bool _isScreenRecordingActive = false;

  @override
  void initState() {
    super.initState();
    _initSecurityMonitoring();
  }

  void _initSecurityMonitoring() async {
    // 1. Listen to the screenshot stream
    _streamSubscription = _noScreenshot.screenshotStream.listen((value) {
      if (!mounted) return;
      debugPrint(
        "Screenshot stream event: wasTaken=${value.wasScreenshotTaken}, isRecording=${value.isScreenRecording}",
      );

      setState(() {});

      if (value.wasScreenshotTaken) {
        debugPrint('Screenshot captured at path: ${value.screenshotPath}');
        _showScreenshotWarningDialog(value);
      }

      if (value.isScreenRecording != _isScreenRecordingActive) {
        setState(() {
          _isScreenRecordingActive = value.isScreenRecording;
        });
      }
    });

    // Check if bypassed in debug mode
    final bool isBypassed = kDebugMode && !SecurityService.enableInDebug;
    if (isBypassed) {
      debugPrint("Security monitoring bypassed in Debug Mode.");
      return;
    }

    // 2. Turn screenshot blocking ON natively
    try {
      await _noScreenshot.screenshotOff();
      debugPrint('screenshotOff successfully activated');
    } catch (e) {
      debugPrint('Error enabling screenshot protection: $e');
    }

    // 3. Start monitoring for screenshot and recording events
    try {
      await _noScreenshot.startScreenshotListening();
      await _noScreenshot.startScreenRecordingListening();
      debugPrint('Screenshot & Recording monitoring started');
    } catch (e) {
      debugPrint('Error starting monitoring: $e');
    }

    // 4. Register callbacks for active screen recording events
    try {
      _noScreenshot.onScreenRecordingStarted = (snapshot) {
        debugPrint("Screen recording callback: started");
        if (!mounted) return;
        setState(() => _isScreenRecordingActive = true);
      };

      _noScreenshot.onScreenRecordingStopped = (snapshot) {
        debugPrint("Screen recording callback: stopped");
        if (!mounted) return;
        setState(() => _isScreenRecordingActive = false);
      };

      _noScreenshot.startCallbacks();
    } catch (e) {
      debugPrint('Error starting callbacks: $e');
    }
  }

  @override
  void dispose() {
    try {
      _streamSubscription?.cancel();
      _noScreenshot.stopScreenshotListening();
      _noScreenshot.stopScreenRecordingListening();
      _noScreenshot.removeAllCallbacks();
      _noScreenshot
          .screenshotOn(); // Cleanly restore capture capability on screen exit
    } catch (e) {
      debugPrint("Disposal cleanup error: $e");
    }
    super.dispose();
  }

  void _showScreenshotWarningDialog(ScreenshotSnapshot snapshot) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.security_rounded,
          size: 48,
          color: Colors.redAccent,
        ),
        title: const Text(
          'Security Violation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        content: Text(
          'Taking screenshots is strictly prohibited on this page to protect sensitive account information.\n\n'
          '${snapshot.screenshotPath.isNotEmpty ? "Path: ${snapshot.screenshotPath}" : ""}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are in Debug Mode and bypass is configured
    final bool isBypassed = kDebugMode && !SecurityService.enableInDebug;
    debugPrint(
      "RecordingGuard build: isBypassed=$isBypassed, enableInDebug=${SecurityService.enableInDebug}, activeRecording=$_isScreenRecordingActive",
    );

    Widget currentChild = widget.child;

    // Apply the Native SecureWidget layer if protection is not bypassed
    if (!isBypassed) {
      currentChild = SecureWidget(
        mode: widget.mode,
        blurRadius: widget.blurRadius,
        child: widget.child,
      );
    }

    // Apply standard overlay layout if active screen recording is detected
    if (_isScreenRecordingActive && !isBypassed) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.videocam_off_rounded,
                      color: Colors.redAccent,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Screen Recording Detected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'For absolute security of your account and credentials, access to this screen is restricted while screen recording is active.\n\nPlease stop your recording to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return currentChild;
  }
}
