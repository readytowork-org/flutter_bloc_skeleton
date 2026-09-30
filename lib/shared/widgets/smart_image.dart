import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../features/optimization/bloc/optimization_bloc.dart';
import '../../features/optimization/bloc/optimization_state.dart';
import '../../core/network/connectivity_service.dart';

class SmartImage extends StatefulWidget {
  final String imageUrl;
  final String? blurHash;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  bool _forceLoad = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptimizationBloc, OptimizationState>(
      builder: (context, state) {
        final isCellular =
            state.connectivityStatus == ConnectionStatus.cellular;
        final dataSaverOn = state.dataSaverMode;

        // If data saver is on, we are on cellular, and user hasn't forced load
        if (dataSaverOn && isCellular && !_forceLoad) {
          return _buildDataSaverPlaceholder();
        }

        return _buildCachedImage();
      },
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      placeholder: (context, url) => widget.blurHash != null
          ? BlurHash(hash: widget.blurHash!)
          : Container(color: Colors.grey[300]),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildDataSaverPlaceholder() {
    return GestureDetector(
      onTap: () => setState(() => _forceLoad = true),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blurred background (dimmed)
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.black.withValues(alpha: 0.1),
            child: widget.blurHash != null
                ? Opacity(opacity: 0.5, child: BlurHash(hash: widget.blurHash!))
                : const SizedBox.shrink(),
          ),
          // Data Saver Icon and Label
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.data_usage, color: Colors.white, size: 32),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Data Saver On\nTap to load",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
