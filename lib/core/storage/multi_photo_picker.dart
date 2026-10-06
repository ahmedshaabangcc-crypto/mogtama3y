import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import 'upload_service.dart';

/// Reusable multi-photo picker used by both the marketplace and real
/// estate "add listing" forms — uploads each photo to the public
/// bucket as it's picked and reports the growing URL list back via
/// [onChanged]. See backend/migrations/0027_storage_and_verification.sql.
class MultiPhotoPicker extends StatefulWidget {
  const MultiPhotoPicker({super.key, required this.purpose, required this.onChanged, this.maxPhotos = 6});
  final String purpose;
  final ValueChanged<List<String>> onChanged;
  final int maxPhotos;

  @override
  State<MultiPhotoPicker> createState() => _MultiPhotoPickerState();
}

class _MultiPhotoPickerState extends State<MultiPhotoPicker> {
  final List<String> _urls = [];
  bool _uploading = false;

  // Several photos at once from the gallery, uploaded one after another.
  Future<void> _add() async {
    final remaining = widget.maxPhotos - _urls.length;
    if (remaining <= 0) return;
    final files = remaining == 1
        ? [?await UploadService.pickImage(source: ImageSource.gallery)]
        : await UploadService.pickImages(limit: remaining);
    if (files.isEmpty) return;
    setState(() => _uploading = true);
    var failed = 0;
    for (final file in files) {
      try {
        final url = await UploadService.uploadPublicPhoto(purpose: widget.purpose, file: file);
        if (!mounted) return;
        setState(() => _urls.add(url));
        widget.onChanged(_urls);
      } catch (_) {
        failed++;
      }
    }
    if (mounted) {
      setState(() => _uploading = false);
      if (failed > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر رفع $failed صورة، حاول مرة أخرى.')));
      }
    }
  }

  void _remove(int index) {
    setState(() => _urls.removeAt(index));
    widget.onChanged(_urls);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < _urls.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_urls[i], cacheWidth: 260, width: 84, height: 84, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    left: 2,
                    child: InkWell(
                      onTap: () => _remove(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_urls.length < widget.maxPhotos)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _uploading ? null : _add,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: _uploading
                    ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                    : const Icon(Icons.add_a_photo_outlined, color: AppColors.inkMuted),
              ),
            ),
        ],
      ),
    );
  }
}
