import '../imports/imports.dart';

/// A service to handle media selection (images, videos, files).
/// Uses system_asset_picker which leverages Android's native Photo Picker
/// without requiring storage permissions.
class MediaService {
  MediaService._();
  static final MediaService instance = MediaService._();

  /// Pick a single image from gallery or camera.
  FutureEither<File?> pickImage({
    required ImageSource source,
  }) async {
    return runTask(() async {
      final XFile? file = await SystemAssetPicker.pickImage(
        source: source,
      );
      return file != null ? File(file.path) : null;
    });
  }

  /// Pick multiple images from gallery.
  FutureEither<List<File>> pickMultiImage({
    int maxItems = 10,
  }) async {
    return runTask(() async {
      final List<String> paths = await SystemAssetPicker.pickMultipleImages(
        maxItems: maxItems,
      );
      return paths.map((path) => File(path)).toList();
    });
  }

  /// Pick a single video from gallery or camera.
  FutureEither<File?> pickVideo({
    required ImageSource source,
  }) async {
    return runTask(() async {
      final XFile? file = await SystemAssetPicker.pickVideo(
        source: source,
      );
      return file != null ? File(file.path) : null;
    });
  }

  /// Pick multiple videos from gallery.
  FutureEither<List<File>> pickMultiVideo({
    int maxItems = 5,
    int maxVideoSizeMB = 100,
  }) async {
    return runTask(() async {
      final List<String> paths = await SystemAssetPicker.pickMultipleVideos(
        maxItems: maxItems,
        maxVideoSizeMB: maxVideoSizeMB,
      );
      return paths.map((path) => File(path)).toList();
    });
  }

  /// Pick both images and videos together.
  FutureEither<List<File>> pickImagesAndVideos({
    int maxItems = 10,
    int maxVideoSizeMB = 100,
  }) async {
    return runTask(() async {
      final List<String> paths = await SystemAssetPicker.pickImagesAndVideos(
        maxItems: maxItems,
        maxVideoSizeMB: maxVideoSizeMB,
      );
      return paths.map((path) => File(path)).toList();
    });
  }

  /// Check if the native Photo Picker is available (Android 11+).
  Future<bool> isPhotoPickerAvailable() async {
    return SystemAssetPicker.isPhotoPickerAvailable();
  }
}
