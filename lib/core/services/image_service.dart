import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// طلب الأذونات المطلوبة للكاميرا والمعرض
  static Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+)
        final Map<Permission, PermissionStatus> permissions = await [
          Permission.camera,
          Permission.photos,
        ].request();

        return permissions[Permission.camera] == PermissionStatus.granted &&
               permissions[Permission.photos] == PermissionStatus.granted;
      } else if (Platform.isIOS) {
        // For iOS
        final Map<Permission, PermissionStatus> permissions = await [
          Permission.camera,
          Permission.photos,
        ].request();

        return permissions[Permission.camera] == PermissionStatus.granted &&
               permissions[Permission.photos] == PermissionStatus.granted;
      }
      return false;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  /// التقاط صورة من الكاميرا
  static Future<File?> pickImageFromCamera() async {
    try {
      print('Starting camera image picker...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        print('Image captured: ${image.path}');
        // حفظ الصورة في مجلد التطبيق
        final savedImage = await _saveImageToAppDirectory(File(image.path));
        print('Image saved: ${savedImage.path}');
        return savedImage;
      }
      
      print('No image captured');
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  /// اختيار صورة من المعرض
  static Future<File?> pickImageFromGallery() async {
    try {
      print('Starting gallery image picker...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        print('Image selected: ${image.path}');
        // حفظ الصورة في مجلد التطبيق
        final savedImage = await _saveImageToAppDirectory(File(image.path));
        print('Image saved: ${savedImage.path}');
        return savedImage;
      }
      
      print('No image selected');
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  /// حفظ الصورة في مجلد التطبيق
  static Future<File> _saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${appDir.path}/profile_images');
      
      // إنشاء المجلد إذا لم يكن موجوداً
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // إنشاء اسم فريد للصورة
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = path.join(profileImagesDir.path, fileName);
      
      // نسخ الصورة إلى المجلد الجديد
      final savedImage = await imageFile.copy(savedImagePath);
      
      return savedImage;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  /// حذف صورة الملف الشخصي القديمة
  static Future<void> deleteOldProfileImage(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
          print('Old profile image deleted: $imagePath');
        }
      } catch (e) {
        print('Error deleting old profile image: $e');
      }
    }
  }

  /// التحقق من وجود الصورة
  static Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// تنظيف جميع صور الملف الشخصي
  static Future<void> clearAllProfileImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${appDir.path}/profile_images');
      
      if (await profileImagesDir.exists()) {
        await profileImagesDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing profile images: $e');
    }
  }

  /// الحصول على حجم الصورة
  static Future<String> getImageSize(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        final bytes = await file.length();
        if (bytes < 1024) {
          return '$bytes B';
        } else if (bytes < 1024 * 1024) {
          return '${(bytes / 1024).toStringAsFixed(1)} KB';
        } else {
          return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
        }
      }
      return '0 B';
    } catch (e) {
      return '0 B';
    }
  }
}