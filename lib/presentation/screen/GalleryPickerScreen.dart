
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'CreatePostScreen.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
abstract class _GC {
  static const bg        = Color(0xFF000000);
  static const surfaceEl = Color(0xFF1C1C1C);
  static const divider   = Color(0xFF262626);
  static const accent    = Color(0xFF0095F6);
  static const textPri   = Color(0xFFFFFFFF);
  static const textSec   = Color(0xFFA8A8A8);
  static const textTer   = Color(0xFF555555);
}

// ─── Aspect Ratio Model ───────────────────────────────────────────────────────
class _AR {
  final String label;
  final double? ratio; // null = original
  const _AR(this.label, this.ratio);
}

const List<_AR> _kRatios = [
  _AR('Original', null),
  _AR('1:1',  1.0),
  _AR('4:5',  4 / 5),
  _AR('16:9', 16 / 9),
];

// ─── CropTransform — gallery → CreatePost tak bhejne ke liye ─────────────────
class CropTransform {
  final Offset offset;
  final double scale;
  final double? aspectRatio;
  const CropTransform({
    required this.offset,
    required this.scale,
    required this.aspectRatio,
  });
}

// Simple helper to detect video vs image from extension
bool _isVideoPath(String path) {
  final p = path.toLowerCase();
  return p.endsWith('.mp4') || p.endsWith('.mov') || p.endsWith('.3gp') ||
      p.endsWith('.mkv') || p.endsWith('.webm') || p.endsWith('.avi');
}

// ═════════════════════════════════════════════════════════════════════════════
//  GALLERY PICKER SCREEN
//  Ab ye khud gallery browse nahi karta — seedha system Photo Picker launch
//  karta hai (image_picker.pickMultipleMedia), jisme koi runtime permission
//  nahi lagta (Google Play Photo & Video Permissions policy compliant).
// ═════════════════════════════════════════════════════════════════════════════
class GalleryPickerScreen extends StatefulWidget {
  const GalleryPickerScreen({super.key});
  @override
  State<GalleryPickerScreen> createState() => _GalleryPickerScreenState();
}

class _GalleryPickerScreenState extends State<GalleryPickerScreen> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> _pickedFiles = [];
  int _primaryIndex = 0; // index in _pickedFiles jiski crop hogi

  bool _loading        = true;
  bool _processingNext = false;
  bool _pickFailed     = false;

  int _ratioIndex = 1; // default 1:1
  CropTransform _cropTransform = const CropTransform(
    offset: Offset.zero, scale: 1.0, aspectRatio: 1.0,
  );

  static const int _maxSelection = 10;

  @override
  void initState() {
    super.initState();
    _launchSystemPicker();
  }

  // ── System Photo Picker launch karo ────────────────────────────────────────
  Future<void> _launchSystemPicker() async {
    setState(() { _loading = true; _pickFailed = false; });
    try {
      final files = await _picker.pickMultipleMedia(
        imageQuality: 90,
        limit: _maxSelection,
      );

      if (!mounted) return;

      if (files.isEmpty) {
        // User ne cancel kar diya — screen band karo
        Navigator.maybePop(context);
        return;
      }

      setState(() {
        _pickedFiles   = files;
        _primaryIndex  = 0;
        _loading       = false;
      });
      _resetCrop();
    } catch (e) {
      if (mounted) setState(() { _loading = false; _pickFailed = true; });
    }
  }

  void _resetCrop() {
    setState(() {
      _cropTransform = CropTransform(
        offset: Offset.zero, scale: 1.0,
        aspectRatio: _kRatios[_ratioIndex].ratio,
      );
    });
  }

  bool get _primaryIsVideo =>
      _pickedFiles.isNotEmpty && _isVideoPath(_pickedFiles[_primaryIndex].path);

  // ── Actual pixel crop → File (same maths jaisa pehle tha) ──────────────────
  Future<File?> _cropToFile(File origFile) async {
    final bytes    = await origFile.readAsBytes();
    final codec    = await ui.instantiateImageCodec(bytes);
    final frame    = await codec.getNextFrame();
    final srcImage = frame.image;

    final srcW = srcImage.width.toDouble();
    final srcH = srcImage.height.toDouble();

    final screenW = MediaQuery.of(context).size.width;

    final double? arRatio = _cropTransform.aspectRatio;
    double cropBoxW = screenW;
    double cropBoxH;
    if (arRatio == null) {
      final naturalH = srcH / srcW * screenW;
      cropBoxH = naturalH.clamp(screenW * 0.56, screenW * 1.25);
    } else {
      cropBoxH = (screenW / arRatio).clamp(0.0, 380.0);
    }

    final fitScaleX = cropBoxW / srcW;
    final fitScaleY = cropBoxH / srcH;
    final fitScale  = fitScaleX > fitScaleY ? fitScaleX : fitScaleY;

    final totalScale = fitScale * _cropTransform.scale;

    final dispW = srcW * totalScale;
    final dispH = srcH * totalScale;

    final imgLeft = (cropBoxW - dispW) / 2 + _cropTransform.offset.dx;
    final imgTop  = (cropBoxH - dispH) / 2 + _cropTransform.offset.dy;

    final srcCropX = (-imgLeft / totalScale).clamp(0.0, srcW - 1);
    final srcCropY = (-imgTop  / totalScale).clamp(0.0, srcH - 1);
    final srcCropW = (cropBoxW / totalScale).clamp(1.0, srcW - srcCropX);
    final srcCropH = (cropBoxH / totalScale).clamp(1.0, srcH - srcCropY);

    final outW = srcCropW.round();
    final outH = srcCropH.round();

    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder, Rect.fromLTWH(0, 0, outW.toDouble(), outH.toDouble()));
    canvas.drawImageRect(
      srcImage,
      Rect.fromLTWH(srcCropX, srcCropY, srcCropW, srcCropH),
      Rect.fromLTWH(0, 0, outW.toDouble(), outH.toDouble()),
      Paint(),
    );
    final picture  = recorder.endRecording();
    final outImage = await picture.toImage(outW, outH);
    srcImage.dispose();

    final byteData = await outImage.toByteData(format: ui.ImageByteFormat.png);
    outImage.dispose();
    if (byteData == null) return null;

    final tmp  = await getTemporaryDirectory();
    final path = '${tmp.path}/crop_${DateTime.now().millisecondsSinceEpoch}.png';
    await File(path).writeAsBytes(byteData.buffer.asUint8List());
    return File(path);
  }

  // ── Next button ───────────────────────────────────────────────────────────
  Future<void> _onNext() async {
    if (_pickedFiles.isEmpty || _processingNext) return;
    HapticFeedback.mediumImpact();
    setState(() => _processingNext = true);

    try {
      final mediaItems = <MediaItem>[];
      for (int i = 0; i < _pickedFiles.length; i++) {
        final path    = _pickedFiles[i].path;
        final isVideo = _isVideoPath(path);
        File file     = File(path);

        // Sirf primary (jiski crop preview dikhi thi) actually crop hoti hai
        if (i == _primaryIndex && !isVideo) {
          final cropped = await _cropToFile(file);
          if (cropped != null) file = cropped;
        }

        mediaItems.add(MediaItem(path: file.path, isImage: !isVideo));
      }

      if (!mounted) return;

      final posted = await Navigator.push<bool>(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => FadeTransition(
            opacity: anim,
            child: CreatePostScreen(initialMedia: mediaItems),
          ),
          transitionDuration: const Duration(milliseconds: 280),
        ),
      );

      if (posted == true && mounted) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _processingNext = false);
    }
  }

  void _removeAt(int i) {
    setState(() {
      _pickedFiles.removeAt(i);
      if (_pickedFiles.isEmpty) {
        Navigator.maybePop(context);
        return;
      }
      if (_primaryIndex >= _pickedFiles.length) {
        _primaryIndex = _pickedFiles.length - 1;
      } else if (i < _primaryIndex) {
        _primaryIndex--;
      }
    });
    _resetCrop();
  }

  void _setPrimary(int i) {
    if (_primaryIndex == i) return;
    setState(() => _primaryIndex = i);
    _resetCrop();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _GC.bg,
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2))
              : _pickFailed
              ? _buildPickFailed()
              : Column(children: [
            _buildTopBar(),

            // ── Crop / Video Preview ──────────────────────────────
            _primaryIsVideo
                ? _VideoPreviewBox(
              key: ValueKey('vid_${_pickedFiles[_primaryIndex].path}'),
              file: File(_pickedFiles[_primaryIndex].path),
            )
                : _CropPreview(
              key: ValueKey('${_pickedFiles[_primaryIndex].path}_$_ratioIndex'),
              file: File(_pickedFiles[_primaryIndex].path),
              aspectRatio: _kRatios[_ratioIndex].ratio,
              onTransformChanged: (t) => _cropTransform = t,
            ),

            // ── Aspect Ratio Bar — sirf image ke liye ───────────────
            if (!_primaryIsVideo) _buildRatioBar(),

            // ── Selected thumbnails strip ────────────────────────────
            _buildThumbStrip(),

            const Spacer(),
          ]),
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: _GC.bg,
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: const Padding(padding: EdgeInsets.all(10),
              child: Icon(Icons.close_rounded, color: _GC.textPri, size: 24)),
        ),
        const Spacer(),
        const Text('New post', style: TextStyle(
            color: _GC.textPri, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
        const Spacer(),
        GestureDetector(
          onTap: (_pickedFiles.isNotEmpty && !_processingNext) ? _onNext : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(
              color: (_pickedFiles.isNotEmpty && !_processingNext)
                  ? _GC.accent : _GC.accent.withOpacity(0.35),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _processingNext
                ? const SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Next', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700,
                fontSize: 14, letterSpacing: -0.2)),
          ),
        ),
      ]),
    );
  }

  // ── Aspect ratio bar ──────────────────────────────────────────────────────
  Widget _buildRatioBar() {
    return Container(
      color: _GC.bg,
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_kRatios.length, (i) {
          final r        = _kRatios[i];
          final selected = i == _ratioIndex;
          return GestureDetector(
            onTap: () {
              if (_ratioIndex == i) return;
              setState(() => _ratioIndex = i);
              _resetCrop();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? _GC.accent.withOpacity(0.15) : _GC.surfaceEl,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: selected ? _GC.accent : Colors.transparent, width: 1),
              ),
              child: Text(r.label, style: TextStyle(
                color: selected ? _GC.accent : _GC.textSec,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              )),
            ),
          );
        }),
      ),
    );
  }

  // ── Selected media thumbnail strip (sirf jab 1 se zyada select ho) ─────────
  Widget _buildThumbStrip() {
    if (_pickedFiles.length <= 1) return const SizedBox.shrink();

    return Container(
      height: 84,
      color: _GC.bg,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _pickedFiles.length,
        itemBuilder: (_, i) {
          final f          = _pickedFiles[i];
          final isVideo    = _isVideoPath(f.path);
          final isPrimary  = i == _primaryIndex;

          return GestureDetector(
            onTap: () => _setPrimary(i),
            child: Container(
              width: 64,
              margin: const EdgeInsets.only(right: 8),
              child: Stack(fit: StackFit.expand, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(f.path), fit: BoxFit.cover),
                ),
                if (isPrimary)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _GC.accent, width: 2),
                    ),
                  ),
                if (isVideo)
                  const Positioned(
                    bottom: 4, left: 4,
                    child: Icon(Icons.play_circle_fill_rounded,
                        color: Colors.white, size: 16,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 3)]),
                  ),
                Positioned(
                  top: 2, right: 2,
                  child: GestureDetector(
                    onTap: () => _removeAt(i),
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  // ── Picker failed / user denied at OS level ─────────────────────────────────
  Widget _buildPickFailed() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: _GC.surfaceEl, shape: BoxShape.circle),
            child: const Icon(Icons.photo_library_outlined, color: Color(0xFFA8A8A8), size: 40),
          ),
          const SizedBox(height: 20),
          const Text('Could not open picker',
              style: TextStyle(color: _GC.textPri, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text(
            'Something went wrong opening the photo picker.\nPlease try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _GC.textSec, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: _launchSystemPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
              decoration: BoxDecoration(color: _GC.accent, borderRadius: BorderRadius.circular(10)),
              child: const Text('Try Again',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  _CropPreview — pinch/pan inside aspect-ratio clipped box
//  Ab AssetEntity ki jagah direct File leta hai.
// ═════════════════════════════════════════════════════════════════════════════
class _CropPreview extends StatefulWidget {
  final File file;
  final double? aspectRatio; // null = original
  final ValueChanged<CropTransform> onTransformChanged;

  const _CropPreview({
    super.key,
    required this.file,
    required this.aspectRatio,
    required this.onTransformChanged,
  });

  @override
  State<_CropPreview> createState() => _CropPreviewState();
}

class _CropPreviewState extends State<_CropPreview> {
  Size   _imageSize  = Size.zero;
  double _scale      = 1.0;
  double _baseScale  = 1.0;
  Offset _offset     = Offset.zero;
  Offset _startFocal = Offset.zero;
  bool   _loaded     = false;

  static const double _previewH = 380.0;
  static const double _maxScale = 5.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(_CropPreview old) {
    super.didUpdateWidget(old);
    if (old.file.path != widget.file.path) {
      setState(() { _loaded = false; _imageSize = Size.zero; _scale = 1.0; _offset = Offset.zero; });
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;
    final bytes = await widget.file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w     = frame.image.width.toDouble();
    final h     = frame.image.height.toDouble();
    frame.image.dispose();

    if (mounted) setState(() { _imageSize = Size(w, h); _loaded = true; });
    _notify();
  }

  Size _cropBox(double screenW) {
    if (widget.aspectRatio == null) {
      if (_imageSize == Size.zero) return Size(screenW, screenW);
      final naturalH = screenW * _imageSize.height / _imageSize.width;
      return Size(screenW, naturalH.clamp(screenW * 0.56, screenW * 1.25));
    }
    final h = (screenW / widget.aspectRatio!).clamp(0.0, _previewH);
    return Size(screenW, h);
  }

  double _fitScale(Size cropBox) {
    if (_imageSize == Size.zero) return 1.0;
    final sx = cropBox.width  / _imageSize.width;
    final sy = cropBox.height / _imageSize.height;
    return sx > sy ? sx : sy;
  }

  Offset _clamp(Offset off, Size cropBox) {
    final fit = _fitScale(cropBox);
    final dw  = _imageSize.width  * fit * _scale;
    final dh  = _imageSize.height * fit * _scale;
    final mx  = ((dw - cropBox.width)  / 2).clamp(0.0, double.infinity);
    final my  = ((dh - cropBox.height) / 2).clamp(0.0, double.infinity);
    return Offset(off.dx.clamp(-mx, mx), off.dy.clamp(-my, my));
  }

  void _notify() {
    widget.onTransformChanged(CropTransform(
      offset: _offset, scale: _scale, aspectRatio: widget.aspectRatio,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cropBox = _cropBox(screenW);
    final fit     = _fitScale(cropBox);

    return SizedBox(
      width: screenW,
      height: cropBox.height,
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: Container(color: Colors.black)),
        Center(
          child: ClipRect(
            child: SizedBox(
              width: cropBox.width,
              height: cropBox.height,
              child: !_loaded
                  ? Container(
                color: _GC.surfaceEl,
                child: const Center(
                  child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2),
                ),
              )
                  : GestureDetector(
                onScaleStart: (d) {
                  _baseScale  = _scale;
                  _startFocal = d.focalPoint - _offset;
                },
                onScaleUpdate: (d) {
                  final newScale = (_baseScale * d.scale).clamp(1.0, _maxScale);
                  final rawOff   = d.focalPoint - _startFocal;
                  setState(() {
                    _scale  = newScale;
                    _offset = _clamp(rawOff, cropBox);
                  });
                  _notify();
                },
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Transform.translate(
                    offset: _offset,
                    child: SizedBox(
                      width:  _imageSize == Size.zero ? screenW  : _imageSize.width  * fit * _scale,
                      height: _imageSize == Size.zero ? cropBox.height : _imageSize.height * fit * _scale,
                      child: Image.file(widget.file, fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: IgnorePointer(
            child: SizedBox(
              width: cropBox.width,
              height: cropBox.height,
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Rule-of-thirds grid painter ───────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final grid = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), border);
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(Offset(size.width  * i / 3, 0),
          Offset(size.width  * i / 3, size.height), grid);
      canvas.drawLine(Offset(0, size.height * i / 3),
          Offset(size.width, size.height * i / 3), grid);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

// ═════════════════════════════════════════════════════════════════════════════
//  _VideoPreviewBox — top preview jab selected primary video ho
//  Ab thumbnailDataWithSize (photo_manager) ki jagah seedha VideoPlayerController
//  se pehla frame paused dikhate hain — koi extra package (video_thumbnail
//  waghera) ki zaroorat nahi.
// ═════════════════════════════════════════════════════════════════════════════
class _VideoPreviewBox extends StatefulWidget {
  final File file;
  const _VideoPreviewBox({super.key, required this.file});
  @override State<_VideoPreviewBox> createState() => _VideoPreviewBoxState();
}

class _VideoPreviewBoxState extends State<_VideoPreviewBox> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying   = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(_VideoPreviewBox old) {
    super.didUpdateWidget(old);
    if (old.file.path != widget.file.path) {
      _controller?.dispose();
      _controller  = null;
      _initialized = false;
      _isPlaying   = false;
      _init();
    }
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.file(widget.file);
    await controller.initialize();
    await controller.setLooping(true);
    if (!mounted) { controller.dispose(); return; }
    setState(() { _controller = controller; _initialized = true; });
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        height: 380,
        width: double.infinity,
        color: Colors.black,
        child: Stack(alignment: Alignment.center, children: [
          if (_initialized && _controller != null)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2)),

          if (!_isPlaying)
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
            ),

          if (_initialized && _controller != null)
            Positioned(
              bottom: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)),
                child: Text(_formatDuration(_controller!.value.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
        ]),
      ),
    );
  }
}




//------------------ With READ_MEDIA_IMAGES and READ_MEDIA_VIDEO permission ---------->





// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';
//
// import 'CreatePostScreen.dart';
//
// // ─── Colors ───────────────────────────────────────────────────────────────────
// abstract class _GC {
//   static const bg        = Color(0xFF000000);
//   static const surfaceEl = Color(0xFF1C1C1C);
//   static const divider   = Color(0xFF262626);
//   static const accent    = Color(0xFF0095F6);
//   static const textPri   = Color(0xFFFFFFFF);
//   static const textSec   = Color(0xFFA8A8A8);
//   static const textTer   = Color(0xFF555555);
// }
//
// // ─── Aspect Ratio Model ───────────────────────────────────────────────────────
// class _AR {
//   final String label;
//   final double? ratio; // null = original
//   const _AR(this.label, this.ratio);
// }
//
// const List<_AR> _kRatios = [
//   _AR('Original', null),
//   _AR('1:1',  1.0),
//   _AR('4:5',  4 / 5),
//   _AR('16:9', 16 / 9),
// ];
//
// // ─── CropTransform — gallery → CreatePost tak bhejne ke liye ─────────────────
// class CropTransform {
//   final Offset offset;
//   final double scale;
//   final double? aspectRatio;
//   const CropTransform({
//     required this.offset,
//     required this.scale,
//     required this.aspectRatio,
//   });
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  GALLERY PICKER SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class GalleryPickerScreen extends StatefulWidget {
//   const GalleryPickerScreen({super.key});
//   @override
//   State<GalleryPickerScreen> createState() => _GalleryPickerScreenState();
// }
//
// class _GalleryPickerScreenState extends State<GalleryPickerScreen> {
//   List<AssetPathEntity> _albums       = [];
//   AssetPathEntity?      _currentAlbum;
//   List<AssetEntity>     _assets       = [];
//   AssetEntity?          _previewAsset;
//   final List<AssetEntity> _selectedAssets = [];
//   static const double _previewH = 380.0;
//
//   bool _loading          = true;
//   bool _loadingMore      = false;
//   bool _multiSelect      = false;
//   bool _permissionDenied = false;
//   bool _processingNext   = false;
//
//   int  _ratioIndex = 1; // default 1:1
//   CropTransform _cropTransform = const CropTransform(
//     offset: Offset.zero, scale: 1.0, aspectRatio: 1.0,
//   );
//
//   // Pagination
//   int  _page    = 0;
//   bool _hasMore = true;
//   static const int _pageSize = 80;
//
//   final ScrollController _gridScroll = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _gridScroll.addListener(_onScroll);
//     _requestAndLoad();
//   }
//
//   @override
//   void dispose() {
//     _gridScroll.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (!_loadingMore && _hasMore &&
//         _gridScroll.position.pixels >= _gridScroll.position.maxScrollExtent - 400) {
//       _loadMore();
//     }
//   }
//
//   // ── Permission + initial load ─────────────────────────────────────────────
//   Future<void> _requestAndLoad() async {
//
//     // final perm = await PhotoManager.requestPermissionExtend(
//     //   requestOption: const PermissionRequestOption(
//     //     androidPermission: AndroidPermission(
//     //       type: RequestType.common, // ✅ image + video dono explicitly maango
//     //       mediaLocation: false,
//     //     ),
//     //   ),
//     // );
//     // if (!perm.isAuth && !perm.hasAccess) {
//     //   if (mounted) setState(() { _loading = false; _permissionDenied = true; });
//     //   return;
//     // }
//
//     // final perm = await PhotoManager.requestPermissionExtend(
//     //   requestOption: const PermissionRequestOption(
//     //     androidPermission: AndroidPermission(
//     //       type: RequestType.common,
//     //       mediaLocation: false,
//     //     ),
//     //   ),
//     // );
//     //
//     // // ✅ Android 13+ pe LIMITED access bhi accept karo
//     // if (!perm.isAuth && !perm.hasAccess && !perm.isLimited) {
//     //   if (mounted) setState(() { _loading = false; _permissionDenied = true; });
//     //   return;
//     // }
//
//     await PhotoManager.setIgnorePermissionCheck(false);
//
//     final perm = await PhotoManager.requestPermissionExtend(
//       requestOption: const PermissionRequestOption(
//         androidPermission: AndroidPermission(
//           type: RequestType.common,
//           mediaLocation: false,
//         ),
//       ),
//     );
//
//     // ✅ isLimited ko explicitly handle karo
//     final hasAnyAccess = perm.isAuth || perm.hasAccess || perm.isLimited;
//
//     if (!hasAnyAccess) {
//       if (mounted) setState(() { _loading = false; _permissionDenied = true; });
//       return;
//     }
//
//     // final filterOption = FilterOptionGroup(
//     //   imageOption: const FilterOption(sizeConstraint: SizeConstraint(ignoreSize: true)),
//     //   orders: [const OrderOption(type: OrderOptionType.updateDate, asc: false)],
//     // );
//     //
//     // final albums = await PhotoManager.getAssetPathList(
//     //   type: RequestType.image, onlyAll: false, filterOption: filterOption,
//     // );
//
//     final filterOption = FilterOptionGroup(
//       imageOption: const FilterOption(sizeConstraint: SizeConstraint(ignoreSize: true)),
//       videoOption: const FilterOption(sizeConstraint: SizeConstraint(ignoreSize: true)), // ✅ video filter
//       orders: [const OrderOption(type: OrderOptionType.updateDate, asc: false)],
//     );
//
//     final albums = await PhotoManager.getAssetPathList(
//       type: RequestType.common, onlyAll: false, filterOption: filterOption, // ✅ image + video dono
//     );
//
//     if (albums.isEmpty) {
//       if (mounted) setState(() => _loading = false);
//       return;
//     }
//
//     final sorted = List<AssetPathEntity>.from(albums)
//       ..sort((a, b) => a.isAll ? -1 : b.isAll ? 1 : a.name.compareTo(b.name));
//
//     final first  = sorted.first;
//     final assets = await first.getAssetListPaged(page: 0, size: _pageSize);
//
//     if (mounted) {
//       setState(() {
//         _albums       = sorted;
//         _currentAlbum = first;
//         _assets       = assets;
//         _previewAsset = assets.isNotEmpty ? assets.first : null;
//         _loading      = false;
//         _hasMore      = assets.length == _pageSize;
//       });
//       _resetCrop();
//     }
//   }
//
//   // ── Pagination ────────────────────────────────────────────────────────────
//   Future<void> _loadMore() async {
//     if (_currentAlbum == null || _loadingMore || !_hasMore) return;
//     setState(() => _loadingMore = true);
//     _page++;
//     final more = await _currentAlbum!.getAssetListPaged(page: _page, size: _pageSize);
//     if (mounted) {
//       setState(() {
//         _assets.addAll(more);
//         _hasMore     = more.length == _pageSize;
//         _loadingMore = false;
//       });
//     }
//   }
//
//   // ── Switch album ──────────────────────────────────────────────────────────
//   Future<void> _switchAlbum(AssetPathEntity album) async {
//     setState(() {
//       _loading = true; _page = 0; _hasMore = true;
//       _assets = []; _previewAsset = null; _selectedAssets.clear();
//     });
//     final assets = await album.getAssetListPaged(page: 0, size: _pageSize);
//     if (mounted) {
//       setState(() {
//         _currentAlbum = album;
//         _assets       = assets;
//         _previewAsset = assets.isNotEmpty ? assets.first : null;
//         _loading      = false;
//         _hasMore      = assets.length == _pageSize;
//       });
//       _resetCrop();
//     }
//   }
//
//   void _resetCrop() {
//     setState(() {
//       _cropTransform = CropTransform(
//         offset: Offset.zero, scale: 1.0,
//         aspectRatio: _kRatios[_ratioIndex].ratio,
//       );
//     });
//   }
//
//   // ── Actual pixel crop → File ──────────────────────────────────────────────
//   Future<File?> _cropToFile(AssetEntity asset) async {
//     final origFile = await asset.file;
//     if (origFile == null) return null;
//
//     final bytes    = await origFile.readAsBytes();
//     final codec    = await ui.instantiateImageCodec(bytes);
//     final frame    = await codec.getNextFrame();
//     final srcImage = frame.image;
//
//     final srcW = srcImage.width.toDouble();
//     final srcH = srcImage.height.toDouble();
//
//     final screenW = MediaQuery.of(context).size.width;
//
//     // ✅ cropBox exactly wahi jo _CropPreview use karta hai
//     final double? arRatio = _cropTransform.aspectRatio;
//     double cropBoxW = screenW;
//     double cropBoxH;
//     // if (arRatio == null) {
//     //   // Original — natural height, koi clamp nahi
//     //   cropBoxH = srcH / srcW * screenW;
//     // }
//     if (arRatio == null) {
//       final naturalH = srcH / srcW * screenW;
//       cropBoxH = naturalH.clamp(screenW * 0.56, screenW * 1.25); // ✅ preview se match
//     }
//     else {
//       cropBoxH = (screenW / arRatio).clamp(0.0, _previewH); // _previewH = 380
//     }
//
//     // fitScale — wahi jo _CropPreviewState._fitScale() return karta hai
//     final fitScaleX = cropBoxW / srcW;
//     final fitScaleY = cropBoxH / srcH;
//     final fitScale  = fitScaleX > fitScaleY ? fitScaleX : fitScaleY;
//
//     final totalScale = fitScale * _cropTransform.scale;
//
//     // ✅ Displayed image dimensions
//     final dispW = srcW * totalScale;
//     final dispH = srcH * totalScale;
//
//     // ✅ OverflowBox center-origin: image center = cropBox center + offset
//     // imgLeft = left edge of image in cropBox coordinate space
//     final imgLeft = (cropBoxW - dispW) / 2 + _cropTransform.offset.dx;
//     final imgTop  = (cropBoxH - dispH) / 2 + _cropTransform.offset.dy;
//
//     // Source pixels jo crop box ke andar hain
//     final srcCropX = (-imgLeft / totalScale).clamp(0.0, srcW - 1);
//     final srcCropY = (-imgTop  / totalScale).clamp(0.0, srcH - 1);
//     final srcCropW = (cropBoxW / totalScale).clamp(1.0, srcW - srcCropX);
//     final srcCropH = (cropBoxH / totalScale).clamp(1.0, srcH - srcCropY);
//
//     final outW = srcCropW.round();
//     final outH = srcCropH.round();
//
//     final recorder = ui.PictureRecorder();
//     final canvas   = Canvas(recorder, Rect.fromLTWH(0, 0, outW.toDouble(), outH.toDouble()));
//     canvas.drawImageRect(
//       srcImage,
//       Rect.fromLTWH(srcCropX, srcCropY, srcCropW, srcCropH),
//       Rect.fromLTWH(0, 0, outW.toDouble(), outH.toDouble()),
//       Paint(),
//     );
//     final picture  = recorder.endRecording();
//     final outImage = await picture.toImage(outW, outH);
//     srcImage.dispose();
//
//     final byteData = await outImage.toByteData(format: ui.ImageByteFormat.png);
//     outImage.dispose();
//     if (byteData == null) return null;
//
//     final tmp  = await getTemporaryDirectory();
//     final path = '${tmp.path}/crop_${DateTime.now().millisecondsSinceEpoch}.png';
//     await File(path).writeAsBytes(byteData.buffer.asUint8List());
//     return File(path);
//   }
//
//   // ── Next button ───────────────────────────────────────────────────────────
//   Future<void> _onNext() async {
//     if (_previewAsset == null || _processingNext) return;
//     HapticFeedback.mediumImpact();
//     setState(() => _processingNext = true);
//
//     try {
//       final toUse = (_multiSelect && _selectedAssets.isNotEmpty)
//           ? List<AssetEntity>.from(_selectedAssets)
//           : [_previewAsset!];
//
//       final mediaItems = <MediaItem>[];
//       for (int i = 0; i < toUse.length; i++) {
//         final asset   = toUse[i];
//         final isVideo = asset.type == AssetType.video; // ✅ video check
//         File? file;
//         if (i == 0 && !isVideo) {
//           // Primary image: actual crop apply karo (video par crop apply nahi hota)
//           file = await _cropToFile(asset);
//         }
//         file ??= await asset.file;
//         if (file != null) {
//           mediaItems.add(MediaItem(path: file.path, isImage: !isVideo)); // ✅ video → isImage false
//         }
//       }
//
//       if (!mounted) return;
//
//       // Navigator.pushReplacement(
//       //   context,
//       //   PageRouteBuilder(
//       //     pageBuilder: (_, anim, __) => FadeTransition(
//       //       opacity: anim,
//       //       child: CreatePostScreen(initialMedia: mediaItems),
//       //     ),
//       //     transitionDuration: const Duration(milliseconds: 280),
//       //   ),
//       // );
//
//       // BAAD MEIN (ye lagao):
//       final posted = await Navigator.push<bool>(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (_, anim, __) => FadeTransition(
//             opacity: anim,
//             child: CreatePostScreen(initialMedia: mediaItems),
//           ),
//           transitionDuration: const Duration(milliseconds: 280),
//         ),
//       );
//
//       if (posted == true && mounted) {
//         Navigator.pop(context, true); // ✅ GalleryPicker bhi pop ho jaayega
//       }
//
//     } finally {
//       if (mounted) setState(() => _processingNext = false);
//     }
//   }
//
// //------- image size worrning ------------------------------------------------->
//
//   void _checkOriginalSizeLimitAndWarn(AssetEntity? asset) {
//     if (asset == null) return;
//     final screenW  = MediaQuery.of(context).size.width;
//     final assetW   = asset.width.toDouble();
//     final assetH   = asset.height.toDouble();
//     if (assetW == 0) return;
//
//     final naturalH = screenW * assetH / assetW;
//     if (naturalH > screenW * 1.25) {
//       ScaffoldMessenger.of(context)
//         ..clearSnackBars()
//         ..showSnackBar(SnackBar(
//           content: const Row(children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'Full-size image upload not possible due to height limit.',
//                 style: TextStyle(color: Colors.white, fontSize: 13),
//               ),
//             ),
//           ]),
//           backgroundColor: const Color(0xFFE65100),
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           duration: const Duration(seconds: 3),
//         ));
//     }
//   }
//
//   // ── Album picker bottom sheet ─────────────────────────────────────────────
//   void _showAlbumPicker() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => Container(
//         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//         decoration: const BoxDecoration(
//           color: Color(0xFF1C1C1C),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(
//             margin: const EdgeInsets.only(top: 10, bottom: 6),
//             width: 36, height: 4,
//             decoration: BoxDecoration(color: _GC.textTer, borderRadius: BorderRadius.circular(2)),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Text('Albums', style: TextStyle(color: _GC.textPri, fontSize: 16, fontWeight: FontWeight.w700)),
//           ),
//           const Divider(height: 1, thickness: 0.5, color: Color(0xFF262626)),
//           Flexible(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _albums.length,
//               itemBuilder: (_, i) {
//                 final album     = _albums[i];
//                 final isCurrent = _currentAlbum?.id == album.id;
//                 return InkWell(
//                   onTap: () { Navigator.pop(context); _switchAlbum(album); },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                     child: Row(children: [
//                       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                         Text(album.name, style: TextStyle(
//                           color: isCurrent ? _GC.accent : _GC.textPri,
//                           fontSize: 15,
//                           fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
//                         )),
//                         FutureBuilder<int>(
//                           future: album.assetCountAsync,
//                           builder: (_, snap) => snap.hasData
//                               ? Text('${snap.data} photos',
//                               style: const TextStyle(color: Color(0xFFA8A8A8), fontSize: 12))
//                               : const SizedBox.shrink(),
//                         ),
//                       ])),
//                       if (isCurrent) const Icon(Icons.check_rounded, color: _GC.accent, size: 20),
//                     ]),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//         ]),
//       ),
//     );
//   }
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  BUILD
//   // ══════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _GC.bg,
//         body: SafeArea(
//           child: _permissionDenied
//               ? _buildPermissionDenied()
//               : Column(children: [
//             _buildTopBar(),
//             if (_loading && _assets.isEmpty)
//               const Expanded(child: Center(
//                 child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2),
//               ))
//             else ...[
//               // ── Crop Preview ────────────────────────────────────
//               _previewAsset != null
//                   ? (_previewAsset!.type == AssetType.video
//                   ? _VideoPreviewBox(
//                 key: ValueKey('vid_${_previewAsset!.id}'),
//                 asset: _previewAsset!,
//               ) // ✅ video → simple thumbnail + play icon, no crop
//                   : _CropPreview(
//                 key: ValueKey('${_currentAlbum?.id}_${_previewAsset!.id}_$_ratioIndex'),
//                 asset: _previewAsset!,
//                 aspectRatio: _kRatios[_ratioIndex].ratio,
//                 onTransformChanged: (t) => _cropTransform = t,
//               ))
//                   : Container(
//                 height: 380,
//                 color: _GC.surfaceEl,
//                 child: const Center(
//                   child: Icon(Icons.image_outlined, color: Color(0xFF555555), size: 48),
//                 ),
//               ),
//
//               // ── Aspect Ratio Bar ────────────────────────────────
//               _buildRatioBar(),
//              // if (_previewAsset?.type != AssetType.video) _buildRatioBar(),
//
//               // ── Album Header ────────────────────────────────────
//               _buildAlbumHeader(),
//
//               // ── Grid ────────────────────────────────────────────
//               Expanded(child: _buildGrid()),
//             ],
//           ]),
//         ),
//       ),
//     );
//   }
//
//   // ── Top bar ───────────────────────────────────────────────────────────────
//   Widget _buildTopBar() {
//     return Container(
//       color: _GC.bg,
//       padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
//       child: Row(children: [
//         GestureDetector(
//           onTap: () => Navigator.maybePop(context),
//           child: const Padding(padding: EdgeInsets.all(10),
//               child: Icon(Icons.close_rounded, color: _GC.textPri, size: 24)),
//         ),
//         const Spacer(),
//         const Text('New post', style: TextStyle(
//             color: _GC.textPri, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
//         const Spacer(),
//         // Multi-select toggle
//         GestureDetector(
//           onTap: (_previewAsset != null && !_processingNext) ? _onNext : null,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
//             decoration: BoxDecoration(
//               color: (_previewAsset != null && !_processingNext)
//                   ? _GC.accent : _GC.accent.withOpacity(0.35),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: _processingNext
//                 ? const SizedBox(width: 16, height: 16,
//                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                 : const Text('Next', style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.w700,
//                 fontSize: 14, letterSpacing: -0.2)),
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── Aspect ratio bar ──────────────────────────────────────────────────────
//   Widget _buildRatioBar() {
//     return Container(
//       color: _GC.bg,
//       height: 44,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(_kRatios.length, (i) {
//           final r        = _kRatios[i];
//           final selected = i == _ratioIndex;
//           return GestureDetector(
//             onTap: () {
//               if (_ratioIndex == i) return;
//               setState(() => _ratioIndex = i);
//               _resetCrop();
//               if (i == 0) _checkOriginalSizeLimitAndWarn(_previewAsset); // ✅
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 180),
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//               decoration: BoxDecoration(
//                 color: selected ? _GC.accent.withOpacity(0.15) : _GC.surfaceEl,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                     color: selected ? _GC.accent : Colors.transparent, width: 1),
//               ),
//               child: Text(r.label, style: TextStyle(
//                 color: selected ? _GC.accent : _GC.textSec,
//                 fontSize: 12,
//                 fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
//               )),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   // ── Album header ──────────────────────────────────────────────────────────
//   Widget _buildAlbumHeader() {
//     return Container(
//       color: _GC.bg,
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//       child: Row(children: [
//         GestureDetector(
//           onTap: _showAlbumPicker,
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             Text(_currentAlbum?.name ?? 'Recents',
//                 style: const TextStyle(
//                     color: _GC.textPri, fontSize: 17, fontWeight: FontWeight.w700)),
//             const SizedBox(width: 4),
//             const Icon(Icons.keyboard_arrow_down_rounded, color: _GC.textPri, size: 22),
//           ]),
//         ),
//         const Spacer(),
//         if (_multiSelect && _selectedAssets.isNotEmpty)
//           AnimatedOpacity(
//             opacity: 1, duration: const Duration(milliseconds: 200),
//             child: Text('${_selectedAssets.length} selected',
//                 style: const TextStyle(color: _GC.accent, fontSize: 13, fontWeight: FontWeight.w600)),
//           ),
//       ]),
//     );
//   }
//
//   // ── Photo grid ────────────────────────────────────────────────────────────
//   Widget _buildGrid() {
//     return GridView.builder(
//       controller: _gridScroll,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4, mainAxisSpacing: 1.5, crossAxisSpacing: 1.5,
//       ),
//       itemCount: _assets.length + (_loadingMore ? 4 : 0),
//       itemBuilder: (_, i) {
//         if (i >= _assets.length) return Container(color: _GC.surfaceEl);
//
//         final asset         = _assets[i];
//         final isPreview     = _previewAsset?.id == asset.id;
//         final selectedIndex = _selectedAssets.indexOf(asset);
//         final isSelected    = selectedIndex >= 0;
//
//         return GestureDetector(
//           onTap: () {
//             HapticFeedback.selectionClick();
//             if (_multiSelect) {
//               setState(() {
//                 if (isSelected) {
//                   _selectedAssets.remove(asset);
//                 } else {
//                   _selectedAssets.add(asset);
//                   _previewAsset = asset;
//                 }
//               });
//             } else {
//               setState(() => _previewAsset = asset);
//               _resetCrop();
//               if (_ratioIndex == 0) _checkOriginalSizeLimitAndWarn(asset); // ✅
//             }
//           },
//           child: Stack(fit: StackFit.expand, children: [
//             _AssetThumbnail(asset: asset),
//             if (!_multiSelect && !isPreview)
//               Container(color: Colors.black.withOpacity(0.12)),
//             if (_multiSelect && isSelected)
//               Container(color: _GC.accent.withOpacity(0.2)),
//             if (!_multiSelect && isPreview)
//               Container(decoration: BoxDecoration(
//                   border: Border.all(color: _GC.accent, width: 3))),
//             if (_multiSelect)
//               Positioned(
//                 top: 6, right: 6,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 150),
//                   width: 22, height: 22,
//                   decoration: BoxDecoration(
//                     color: isSelected ? _GC.accent : Colors.transparent,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                     boxShadow: [BoxShadow(
//                         color: Colors.black.withOpacity(0.5), blurRadius: 4)],
//                   ),
//                   child: isSelected
//                       ? Center(child: Text('${selectedIndex + 1}',
//                       style: const TextStyle(color: Colors.white, fontSize: 10,
//                           fontWeight: FontWeight.w700)))
//                       : null,
//                 ),
//               ),
//           ]),
//         );
//       },
//     );
//   }
//
//   // ── Permission denied ─────────────────────────────────────────────────────
//   Widget _buildPermissionDenied() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(
//             width: 80, height: 80,
//             decoration: BoxDecoration(color: _GC.surfaceEl, shape: BoxShape.circle),
//             child: const Icon(Icons.photo_library_outlined, color: Color(0xFFA8A8A8), size: 40),
//           ),
//           const SizedBox(height: 20),
//           const Text('Photo access required',
//               style: TextStyle(color: _GC.textPri, fontSize: 18, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 10),
//           const Text(
//             'Allow photo library access in Settings\nto select images for your posts.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: _GC.textSec, fontSize: 14, height: 1.5),
//           ),
//           const SizedBox(height: 28),
//           GestureDetector(
//             onTap: () => PhotoManager.openSetting(),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
//               decoration: BoxDecoration(color: _GC.accent, borderRadius: BorderRadius.circular(10)),
//               child: const Text('Open Settings',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  _CropPreview — pinch/pan inside aspect-ratio clipped box
// // ═════════════════════════════════════════════════════════════════════════════
// class _CropPreview extends StatefulWidget {
//   final AssetEntity  asset;
//   final double?      aspectRatio; // null = original
//   final ValueChanged<CropTransform> onTransformChanged;
//
//   const _CropPreview({
//     super.key,
//     required this.asset,
//     required this.aspectRatio,
//     required this.onTransformChanged,
//   });
//
//   @override
//   State<_CropPreview> createState() => _CropPreviewState();
// }
//
// class _CropPreviewState extends State<_CropPreview> {
//   File?  _file;
//   Size   _imageSize  = Size.zero;
//   double _scale      = 1.0;
//   double _baseScale  = 1.0;
//   Offset _offset     = Offset.zero;
//   Offset _startFocal = Offset.zero;
//
//   static const double _previewH = 380.0;
//   static const double _maxScale = 5.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFile();
//   }
//
//   Future<void> _loadFile() async {
//     final file = await widget.asset.file;
//     if (!mounted || file == null) return;
//
//     final bytes = await file.readAsBytes();
//     final codec = await ui.instantiateImageCodec(bytes);
//     final frame = await codec.getNextFrame();
//     final w     = frame.image.width.toDouble();
//     final h     = frame.image.height.toDouble();
//     frame.image.dispose();
//
//     if (mounted) setState(() { _file = file; _imageSize = Size(w, h); });
//     _notify();
//   }
//
//   // AFTER
//   Size _cropBox(double screenW) {
//     if (widget.aspectRatio == null) {
//       if (_imageSize == Size.zero) return Size(screenW, screenW);
//       final naturalH = screenW * _imageSize.height / _imageSize.width;
//       // ✅ CreatePostScreen jaisi hi limit — overflow gone
//       return Size(screenW, naturalH.clamp(screenW * 0.56, screenW * 1.25));
//     }
//     final h = (screenW / widget.aspectRatio!).clamp(0.0, _previewH);
//     return Size(screenW, h);
//   }
//
//   // fitScale: scale at which image exactly fills crop box (zoom=1)
//   double _fitScale(Size cropBox) {
//     if (_imageSize == Size.zero) return 1.0;
//     final sx = cropBox.width  / _imageSize.width;
//     final sy = cropBox.height / _imageSize.height;
//     return sx > sy ? sx : sy;
//   }
//
//   // Clamp offset so image never shows gaps inside crop box
//   Offset _clamp(Offset off, Size cropBox) {
//     final fit = _fitScale(cropBox);
//     final dw  = _imageSize.width  * fit * _scale;
//     final dh  = _imageSize.height * fit * _scale;
//     final mx  = ((dw - cropBox.width)  / 2).clamp(0.0, double.infinity);
//     final my  = ((dh - cropBox.height) / 2).clamp(0.0, double.infinity);
//     return Offset(off.dx.clamp(-mx, mx), off.dy.clamp(-my, my));
//   }
//
//   void _notify() {
//     widget.onTransformChanged(CropTransform(
//       offset: _offset, scale: _scale, aspectRatio: widget.aspectRatio,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenW = MediaQuery.of(context).size.width;
//     final cropBox = _cropBox(screenW);
//     final fit     = _fitScale(cropBox);
//
//     // ✅ height = cropBox.height (Original pe natural, baaki pe clamped)
//     return SizedBox(
//       width: screenW,
//       height: cropBox.height,
//       child: Stack(alignment: Alignment.center, children: [
//         Positioned.fill(child: Container(color: Colors.black)),
//         Center(
//           child: ClipRect(
//             child: SizedBox(
//               width: cropBox.width,
//               height: cropBox.height,
//               child: _file == null
//                   ? Container(
//                 color: _GC.surfaceEl,
//                 child: const Center(
//                   child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2),
//                 ),
//               )
//                   : GestureDetector(
//                 onScaleStart: (d) {
//                   _baseScale  = _scale;
//                   _startFocal = d.focalPoint - _offset;
//                 },
//                 onScaleUpdate: (d) {
//                   final newScale = (_baseScale * d.scale).clamp(1.0, _maxScale);
//                   final rawOff   = d.focalPoint - _startFocal;
//                   setState(() {
//                     _scale  = newScale;
//                     _offset = _clamp(rawOff, cropBox);
//                   });
//                   _notify();
//                 },
//                 child: OverflowBox(
//                   maxWidth: double.infinity,
//                   maxHeight: double.infinity,
//                   child: Transform.translate(
//                     offset: _offset,
//                     child: SizedBox(
//                       width:  _imageSize == Size.zero ? screenW  : _imageSize.width  * fit * _scale,
//                       height: _imageSize == Size.zero ? cropBox.height : _imageSize.height * fit * _scale,
//                       child: Image.file(_file!, fit: BoxFit.fill),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // Rule-of-thirds grid
//         Center(
//           child: IgnorePointer(
//             child: SizedBox(
//               width: cropBox.width,
//               height: cropBox.height,
//               child: CustomPaint(painter: _GridPainter()),
//             ),
//           ),
//         ),
//         // Dim strips — Original pe zero height hongi (naturally)
//         // Isliye yeh check unnecessary ho jaata hai, but rakho safety ke liye
//       ]),
//     );
//   }
// }
//
// // ── Rule-of-thirds grid painter ───────────────────────────────────────────────
// class _GridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final border = Paint()
//       ..color = Colors.white.withOpacity(0.85)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.2;
//     final grid = Paint()
//       ..color = Colors.white.withOpacity(0.22)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.5;
//
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), border);
//     for (int i = 1; i < 3; i++) {
//       canvas.drawLine(Offset(size.width  * i / 3, 0),
//           Offset(size.width  * i / 3, size.height), grid);
//       canvas.drawLine(Offset(0, size.height * i / 3),
//           Offset(size.width, size.height * i / 3), grid);
//     }
//   }
//   @override bool shouldRepaint(covariant CustomPainter _) => false;
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  _AssetThumbnail — grid cell
// // ═════════════════════════════════════════════════════════════════════════════
//
// class _AssetThumbnail extends StatefulWidget {
//   final AssetEntity asset;
//   const _AssetThumbnail({super.key, required this.asset});
//   @override State<_AssetThumbnail> createState() => _AssetThumbnailState();
// }
//
// class _AssetThumbnailState extends State<_AssetThumbnail> {
//   Uint8List? _bytes;
//
//   @override void initState() { super.initState(); _load(); }
//
//   @override
//   void didUpdateWidget(_AssetThumbnail old) {
//     super.didUpdateWidget(old);
//     if (old.asset.id != widget.asset.id) { setState(() => _bytes = null); _load(); }
//   }
//
//   Future<void> _load() async {
//     final b = await widget.asset.thumbnailDataWithSize(
//         const ThumbnailSize(200, 200), quality: 75);
//     if (mounted) setState(() => _bytes = b);
//   }
//
//   // ✅ NEW — video duration ko "0:12" format me convert karo
//   String _formatDuration(Duration d) {
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isVideo = widget.asset.type == AssetType.video; // ✅ NEW
//
//     return Stack(fit: StackFit.expand, children: [
//       _bytes == null
//           ? Container(color: const Color(0xFF1C1C1C))
//           : Image.memory(_bytes!, fit: BoxFit.cover),
//
//       // ✅ NEW — Video badge: top-right play icon + bottom-right duration
//       if (isVideo) ...[
//         const Positioned(
//           top: 4, right: 4,
//           child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 18,
//               shadows: [Shadow(color: Colors.black54, blurRadius: 3)]),
//         ),
//         Positioned(
//           bottom: 4, right: 4,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.65),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: Text(_formatDuration(widget.asset.videoDuration),
//                 style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
//           ),
//         ),
//       ],
//     ]);
//   }
// }
//
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  _VideoPreviewBox — top preview jab selected asset video ho
// // ═════════════════════════════════════════════════════════════════════════════
// class _VideoPreviewBox extends StatefulWidget {
//   final AssetEntity asset;
//   const _VideoPreviewBox({super.key, required this.asset});
//   @override State<_VideoPreviewBox> createState() => _VideoPreviewBoxState();
// }
//
// class _VideoPreviewBoxState extends State<_VideoPreviewBox> {
//   Uint8List? _thumbBytes;
//   VideoPlayerController? _controller; // ✅ NEW
//   bool _isPlaying   = false;           // ✅ NEW
//   bool _initialized = false;           // ✅ NEW
//
//   @override
//   void initState() {
//     super.initState();
//     _loadThumb();
//   }
//
//   @override
//   void didUpdateWidget(_VideoPreviewBox old) {
//     super.didUpdateWidget(old);
//     if (old.asset.id != widget.asset.id) {
//       // ✅ Asset badalne par purana controller dispose karo, naya thumb load karo
//       _controller?.dispose();
//       _controller  = null;
//       _initialized = false;
//       _isPlaying   = false;
//       setState(() => _thumbBytes = null);
//       _loadThumb();
//     }
//   }
//
//   Future<void> _loadThumb() async {
//     final b = await widget.asset.thumbnailDataWithSize(
//         const ThumbnailSize(720, 720), quality: 90);
//     if (mounted) setState(() => _thumbBytes = b);
//   }
//
//   // ✅ NEW — Tap hone par actual video file load karke play karo
//   Future<void> _playVideo() async {
//     if (_controller != null) {
//       // Already initialized — bas toggle karo
//       setState(() {
//         if (_controller!.value.isPlaying) {
//           _controller!.pause();
//           _isPlaying = false;
//         } else {
//           _controller!.play();
//           _isPlaying = true;
//         }
//       });
//       return;
//     }
//
//     final file = await widget.asset.file;
//     if (file == null || !mounted) return;
//
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     await controller.setLooping(true);
//
//     if (!mounted) {
//       controller.dispose();
//       return;
//     }
//
//     setState(() {
//       _controller  = controller;
//       _initialized = true;
//       _isPlaying   = true;
//     });
//     controller.play();
//   }
//
//   String _formatDuration(Duration d) {
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose(); // ✅ NEW — memory leak avoid karo
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _playVideo, // ✅ NEW — tap se play/pause
//       child: Container(
//         height: 380,
//         width: double.infinity,
//         color: Colors.black,
//         child: Stack(alignment: Alignment.center, children: [
//           // ✅ Video ready hai to actual VideoPlayer dikhao, warna thumbnail
//           if (_initialized && _controller != null)
//             Center(
//               child: AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: VideoPlayer(_controller!),
//               ),
//             )
//           else
//             _thumbBytes == null
//                 ? const Center(child: CircularProgressIndicator(color: _GC.accent, strokeWidth: 2))
//                 : Positioned.fill(child: Image.memory(_thumbBytes!, fit: BoxFit.contain)),
//
//           // ✅ Play/Pause icon — jab paused ho tabhi dikhao (Instagram jaisa)
//           if (!_isPlaying)
//             Container(
//               width: 64, height: 64,
//               decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
//               child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
//             ),
//
//           Positioned(
//             bottom: 12, right: 12,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)),
//               child: Text(_formatDuration(widget.asset.videoDuration),
//                   style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }



























