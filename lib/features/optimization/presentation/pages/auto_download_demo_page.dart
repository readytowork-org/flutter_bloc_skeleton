import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/optimization_bloc.dart';
import '../../bloc/optimization_state.dart';
import '../../../../core/network/connectivity_service.dart';

class DemoDownloadItem {
  final String id;
  final String title;
  final String size;
  final double totalSizeBytes;
  final IconData icon;
  final Color color;
  final String type; // 'pdf', 'video', 'image'

  double progress; // 0.0 to 1.0
  bool isDownloading;
  bool isCached;
  bool isPaused;
  double speedMbps;

  DemoDownloadItem({
    required this.id,
    required this.title,
    required this.size,
    required this.totalSizeBytes,
    required this.icon,
    required this.color,
    required this.type,
    this.progress = 0.0,
    this.isDownloading = false,
    this.isCached = false,
    this.isPaused = false,
    this.speedMbps = 0.0,
  });
}

class AutoDownloadDemoPage extends StatefulWidget {
  const AutoDownloadDemoPage({super.key});

  @override
  State<AutoDownloadDemoPage> createState() => _AutoDownloadDemoPageState();
}

class _AutoDownloadDemoPageState extends State<AutoDownloadDemoPage> {
  // Mock Connection Status for the simulation
  ConnectionStatus _mockStatus = ConnectionStatus.wifi;
  bool _useMockStatus = true;

  // List of mock download items
  late List<DemoDownloadItem> _items;

  // Simulated background sync logs
  final List<String> _logs = [];
  final ScrollController _logScrollController = ScrollController();
  Timer? _downloadTimer;
  bool _isBackgroundSyncActive = false;

  @override
  void initState() {
    super.initState();
    _resetDemoItems();
    _addLog("Demo initialized. Ready for simulation.");
  }

  void _resetDemoItems() {
    _items = [
      DemoDownloadItem(
        id: "1",
        title: "Product Catalog Spring 2026",
        size: "4.2 MB",
        totalSizeBytes: 4.2 * 1024 * 1024,
        icon: Icons.picture_as_pdf,
        color: Colors.redAccent,
        type: "pdf",
      ),
      DemoDownloadItem(
        id: "2",
        title: "Promo Showcase Video",
        size: "24.8 MB",
        totalSizeBytes: 24.8 * 1024 * 1024,
        icon: Icons.video_library,
        color: Colors.blueAccent,
        type: "video",
      ),
      DemoDownloadItem(
        id: "3",
        title: "Home Banner Splash High-Res",
        size: "1.5 MB",
        totalSizeBytes: 1.5 * 1024 * 1024,
        icon: Icons.image,
        color: Colors.teal,
        type: "image",
      ),
    ];
  }

  @override
  void dispose() {
    _downloadTimer?.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    setState(() {
      _logs.add("[$timeStr] $message");
    });
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  ConnectionStatus _getActiveStatus(OptimizationState state) {
    return _useMockStatus ? _mockStatus : state.connectivityStatus;
  }

  // Starts the download loop for downloading items
  void _startDownloadLoop(OptimizationState state) {
    if (_downloadTimer != null && _downloadTimer!.isActive) return;

    _downloadTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final activeStatus = _getActiveStatus(state);
      final autoWifi = state.autoDownloadOnWifi;

      if (activeStatus == ConnectionStatus.none) {
        // Pause all active downloads
        bool changed = false;
        for (var item in _items) {
          if (item.isDownloading) {
            item.isDownloading = false;
            item.isPaused = true;
            _addLog("⚠️ Network lost. Paused download for '${item.title}'");
            changed = true;
          }
        }
        if (changed) setState(() {});
        return;
      }

      bool anyActive = false;
      for (var item in _items) {
        if (item.isCached) continue;

        // Auto-download Wi-Fi constraint check
        final onCellular = activeStatus == ConnectionStatus.cellular;
        if (onCellular && autoWifi && !item.isDownloading && !item.isPaused) {
          // It's cellular and auto download on Wi-Fi is enabled - pause or mark pending
          continue;
        }

        if (item.isDownloading && !item.isPaused) {
          anyActive = true;
          setState(() {
            // Speed simulation based on connection
            final speed = activeStatus == ConnectionStatus.wifi ? 4.5 : 1.2;
            item.speedMbps = speed;
            final progressDelta =
                (speed * 1024 * 1024 * 0.5) / item.totalSizeBytes;
            item.progress = (item.progress + progressDelta).clamp(0.0, 1.0);

            if (item.progress >= 1.0) {
              item.isDownloading = false;
              item.isCached = true;
              item.speedMbps = 0.0;
              _addLog("✅ Cached ready (offline): '${item.title}'");
            }
          });
        }
      }

      if (!anyActive) {
        _downloadTimer?.cancel();
      }
    });
  }

  void _triggerSingleDownload(DemoDownloadItem item, OptimizationState state) {
    final activeStatus = _getActiveStatus(state);
    if (activeStatus == ConnectionStatus.none) {
      _addLog("❌ Cannot start download. No connection available.");
      return;
    }

    setState(() {
      item.isDownloading = true;
      item.isPaused = false;
      item.isCached = false;
    });

    _addLog("📥 Initiated download for '${item.title}' (${item.size})");
    _startDownloadLoop(state);
  }

  void _pauseDownload(DemoDownloadItem item) {
    setState(() {
      item.isDownloading = false;
      item.isPaused = true;
      item.speedMbps = 0.0;
    });
    _addLog("⏸️ Paused download for '${item.title}'");
  }

  // Mock Workmanager Background Worker
  Future<void> _simulateBackgroundSync(OptimizationState state) async {
    if (_isBackgroundSyncActive) return;

    setState(() {
      _isBackgroundSyncActive = true;
    });

    _addLog(
      "⚙️ Mock Workmanager: Triggering background worker periodic task...",
    );
    await Future.delayed(const Duration(seconds: 1));

    final activeStatus = _getActiveStatus(state);
    if (activeStatus == ConnectionStatus.wifi) {
      _addLog(
        "⚙️ Mock Workmanager: Wi-Fi detected! Starting auto-downloads...",
      );
      await Future.delayed(const Duration(seconds: 1));

      for (var item in _items) {
        if (!item.isCached && !item.isDownloading) {
          _addLog("⚙️ Mock Workmanager: Auto-caching '${item.title}'...");
          _triggerSingleDownload(item, state);
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }
    } else if (activeStatus == ConnectionStatus.cellular) {
      _addLog("⚙️ Mock Workmanager: Cellular detected.");
      if (state.autoDownloadOnWifi) {
        _addLog(
          "⚙️ Mock Workmanager: Auto-download constraint active. Delaying heavy files sync.",
        );
      } else {
        _addLog(
          "⚙️ Mock Workmanager: Auto-download on Wi-Fi is disabled. Proceeding over Cellular...",
        );
        for (var item in _items) {
          if (!item.isCached && !item.isDownloading) {
            _triggerSingleDownload(item, state);
            await Future.delayed(const Duration(milliseconds: 800));
          }
        }
      }
    } else {
      _addLog("⚙️ Mock Workmanager: Sync skipped. No connection.");
    }

    setState(() {
      _isBackgroundSyncActive = false;
    });
  }

  void _clearCache() {
    _downloadTimer?.cancel();
    setState(() {
      _resetDemoItems();
    });
    _addLog("🗑️ Cleared demo cache. Resources reset.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        title: const Text(
          "Auto-Download Demo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearCache,
            tooltip: "Clear Cache",
          ),
        ],
      ),
      body: BlocBuilder<OptimizationBloc, OptimizationState>(
        builder: (context, state) {
          final activeStatus = _getActiveStatus(state);
          return Column(
            children: [
              _buildConnectionBanner(activeStatus),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildSimulatorCard(state),
                    const SizedBox(height: 16),
                    _buildSettingsStatusCard(state),
                    const SizedBox(height: 16),
                    _buildMediaSection(activeStatus, state),
                    const SizedBox(height: 16),
                    _buildTerminalCard(state),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Top active status banner
  Widget _buildConnectionBanner(ConnectionStatus status) {
    IconData icon;
    String text;
    Gradient gradient;

    switch (status) {
      case ConnectionStatus.wifi:
        icon = Icons.wifi;
        text = "Wi-Fi Simulator Mode Active";
        gradient = const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        );
        break;
      case ConnectionStatus.cellular:
        icon = Icons.signal_cellular_alt;
        text = "Cellular Simulator Mode Active";
        gradient = const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
        );
        break;
      case ConnectionStatus.none:
        icon = Icons.cloud_off;
        text = "Offline Mode Active (No Network)";
        gradient = const LinearGradient(
          colors: [Color(0xFFC62828), Color(0xFFE53935)],
        );
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Sleek Glassmorphic Network Simulator Card
  Widget _buildSimulatorCard(OptimizationState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Connectivity Simulator",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Use Mock",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: _useMockStatus,
                    onChanged: (val) {
                      setState(() {
                        _useMockStatus = val;
                      });
                      _addLog(
                        val
                            ? "Switched to simulated connectivity status."
                            : "Restored live device connectivity status.",
                      );
                    },
                    activeThumbColor: const Color(0xFF8E24AA),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: _useMockStatus ? 1.0 : 0.4,
            child: Row(
              children: [
                _buildSimButton(
                  ConnectionStatus.wifi,
                  Icons.wifi,
                  "Wi-Fi",
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _buildSimButton(
                  ConnectionStatus.cellular,
                  Icons.signal_cellular_alt,
                  "Cellular",
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildSimButton(
                  ConnectionStatus.none,
                  Icons.cloud_off,
                  "Offline",
                  Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimButton(
    ConnectionStatus status,
    IconData icon,
    String label,
    Color activeColor,
  ) {
    final isSelected = _useMockStatus && _mockStatus == status;
    return Expanded(
      child: InkWell(
        onTap: !_useMockStatus
            ? null
            : () {
                setState(() {
                  _mockStatus = status;
                });
                _addLog("Simulated connection changed to $label.");
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.15)
                : const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : Colors.white.withValues(alpha: 0.04),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : Colors.white38,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card displaying optimization settings synchrony
  Widget _buildSettingsStatusCard(OptimizationState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161622),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSettingsIndicator(
            Icons.wifi_protected_setup,
            "Auto Wi-Fi Sync",
            state.autoDownloadOnWifi,
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          _buildSettingsIndicator(
            Icons.data_saver_on,
            "Data Saver Mode",
            state.dataSaverMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsIndicator(IconData icon, String title, bool enabled) {
    return Row(
      children: [
        Icon(
          icon,
          color: enabled ? const Color(0xFF8E24AA) : Colors.white30,
          size: 18,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
            Text(
              enabled ? "ON" : "OFF",
              style: TextStyle(
                color: enabled ? Colors.green : Colors.white30,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Media Download Queue List
  Widget _buildMediaSection(
    ConnectionStatus activeStatus,
    OptimizationState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            "Auto-Download Queue",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ..._items.map((item) => _buildMediaCard(item, activeStatus, state)),
      ],
    );
  }

  Widget _buildMediaCard(
    DemoDownloadItem item,
    ConnectionStatus activeStatus,
    OptimizationState state,
  ) {
    final autoWifi = state.autoDownloadOnWifi;
    final isCellular = activeStatus == ConnectionStatus.cellular;

    // Determine status tag and color
    String statusText = "Ready to download";
    Color statusColor = Colors.white38;
    bool showForceDownload = false;

    if (item.isCached) {
      statusText = "Cached (Offline Ready)";
      statusColor = Colors.green;
    } else if (item.isDownloading) {
      statusText =
          "Downloading (${(item.progress * 100).toInt()}%) - ${item.speedMbps.toStringAsFixed(1)} MB/s";
      statusColor = const Color(0xFF8E24AA);
    } else if (item.isPaused) {
      statusText = "Paused";
      statusColor = Colors.orangeAccent;
    } else if (isCellular && autoWifi) {
      statusText = "Pending Wi-Fi (Saved mobile data)";
      statusColor = Colors.amber;
      showForceDownload = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCached
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.04),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.size,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildActionControl(item, showForceDownload, activeStatus, state),
            ],
          ),
          if (item.isDownloading && !item.isCached) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: const Color(0xFF12121A),
                color: const Color(0xFF8E24AA),
                minHeight: 5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionControl(
    DemoDownloadItem item,
    bool showForce,
    ConnectionStatus activeStatus,
    OptimizationState state,
  ) {
    if (item.isCached) {
      return TextButton.icon(
        onPressed: () => _openImmersivePreview(item),
        icon: const Icon(Icons.remove_red_eye, size: 14, color: Colors.green),
        label: const Text(
          "View",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    if (item.isDownloading) {
      return IconButton(
        icon: const Icon(Icons.pause_circle_outline, color: Colors.orange),
        onPressed: () => _pauseDownload(item),
        tooltip: "Pause",
      );
    }

    if (showForce) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD81B60),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          _addLog("⚡ Cellular override triggered for '${item.title}'");
          _triggerSingleDownload(item, state);
        },
        child: const Text(
          "Force",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.cloud_download_outlined, color: Colors.white60),
      onPressed: activeStatus == ConnectionStatus.none
          ? null
          : () => _triggerSingleDownload(item, state),
      tooltip: "Download Now",
    );
  }

  // Immersive Mock Previews Dialogs
  void _openImmersivePreview(DemoDownloadItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: const Color(0xFF1E1E2A),
              height: 480,
              width: double.infinity,
              child: Column(
                children: [
                  // Immersive Title Bar
                  Container(
                    color: const Color(0xFF12121A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(item.icon, color: item.color, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white60,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Immersive Preview Body
                  Expanded(child: _buildImmersiveContent(item)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImmersiveContent(DemoDownloadItem item) {
    if (item.type == 'pdf') {
      return _buildPDFImmersiveContent();
    } else if (item.type == 'video') {
      return _buildVideoImmersiveContent();
    } else {
      return _buildImageImmersiveContent();
    }
  }

  // High-fidelity Immersive Simulated PDF Document Viewer
  Widget _buildPDFImmersiveContent() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Reader toolbar
          Container(
            color: const Color(0xFFECEFF1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.black54, size: 18),
                const SizedBox(width: 14),
                const Text(
                  "Page 1 of 8",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.zoom_in, color: Colors.black54, size: 18),
                const SizedBox(width: 14),
                const Icon(Icons.print, color: Colors.black54, size: 18),
                const SizedBox(width: 14),
                Icon(Icons.check_circle, color: Colors.green[700], size: 18),
              ],
            ),
          ),
          // Document pages simulation
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red[700],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "OFFLINE READY • LOCAL CACHE",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "PRODUCT CATALOG 2026",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 4, color: Colors.red[600]),
                  const SizedBox(height: 16),
                  _buildMockTextLine(1.0),
                  _buildMockTextLine(0.85),
                  _buildMockTextLine(0.95),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildMockTextLine(0.7),
                  _buildMockTextLine(0.9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockTextLine(double widthFactor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      height: 8,
      width: double.infinity,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // Premium Simulated Video Player Dialog
  Widget _buildVideoImmersiveContent() {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background graphic
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF1E1E2A), Colors.black],
                radius: 1.2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.video_library,
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    size: 64,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Playing Cached Showcase Video",
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          // Player Controls Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black26,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(204),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.offline_pin,
                              color: Colors.green,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "1080p Local Cached",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Centered play indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  // Progress and volume toolbar
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "01:24",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "04:32",
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.3,
                          backgroundColor: Colors.white24,
                          color: Colors.blueAccent,
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(
                            Icons.volume_up,
                            color: Colors.white70,
                            size: 16,
                          ),
                          SizedBox(width: 14),
                          Icon(
                            Icons.closed_caption,
                            color: Colors.white70,
                            size: 16,
                          ),
                          Spacer(),
                          Icon(
                            Icons.fullscreen,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Premium Simulated High-Res Image Viewer Dialog
  Widget _buildImageImmersiveContent() {
    return Container(
      color: const Color(0xFF12121A),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2A),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.teal.withValues(alpha: 0.3),
                            size: 80,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(204),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "100% Caching Ready",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Banner image cache is active. This image will load instantly in offline mode without fetching from network.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  // Interactive Workmanager logs terminal
  Widget _buildTerminalCard(OptimizationState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF161622),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.terminal, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Background Sync Console",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "monospace",
                      ),
                    ),
                  ],
                ),
                ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E24AA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ).onPressed(
                  _isBackgroundSyncActive
                      ? null
                      : () => _simulateBackgroundSync(state),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isBackgroundSyncActive) ...[
                        const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ] else ...[
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                      ],
                      const Text(
                        "Trigger Sync",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Console screen
          Container(
            height: 140,
            padding: const EdgeInsets.all(12),
            child: _logs.isEmpty
                ? const Center(
                    child: Text(
                      "Console clean. Click 'Trigger Sync' to run background task mockup.",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                        fontFamily: "monospace",
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _logScrollController,
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontFamily: "monospace",
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Small extension utility to avoid elevated button syntax verbose
extension _ButtonOnPressed on ButtonStyle {
  Widget onPressed(VoidCallback? action, {required Widget child}) {
    return ElevatedButton(style: this, onPressed: action, child: child);
  }
}
