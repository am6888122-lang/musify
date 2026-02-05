# Assets Directory - Musify

هذا المجلد يحتوي على جميع الأصول المطلوبة لتطبيق Musify.

## البنية

```
assets/
├── images/          # الصور والخلفيات
├── icons/           # الأيقونات المخصصة
├── animations/      # ملفات Lottie للأنيميشن
├── audio/           # ملفات صوتية تجريبية
└── fonts/           # الخطوط المخصصة
```

## ملاحظات مهمة

### في وضع التطوير:
- معظم الصور تُحمل من الإنترنت
- الأيقونات تستخدم Material Icons المدمجة
- الأنيميشن يستخدم أنيميشن Flutter المدمج
- الخطوط تستخدم Google Fonts

### للإنتاج:
1. ضع الصور الفعلية في `images/`
2. أضف الأيقونات المخصصة في `icons/`
3. ضع ملفات Lottie في `animations/`
4. حمّل خطوط Poppins في `fonts/`

## الخطوط المطلوبة

إذا كنت تريد استخدام خطوط محلية بدلاً من Google Fonts:

```
fonts/
├── Poppins-Regular.ttf
├── Poppins-Medium.ttf
├── Poppins-SemiBold.ttf
└── Poppins-Bold.ttf
```

يمكن تحميلها من: https://fonts.google.com/specimen/Poppins

## الصور المقترحة

### للشاشات:
- `splash_logo.png` - شعار شاشة البداية
- `onboarding_1.png` - صورة الشاشة التعريفية الأولى
- `onboarding_2.png` - صورة الشاشة التعريفية الثانية  
- `onboarding_3.png` - صورة الشاشة التعريفية الثالثة

### للموسيقى:
- `default_album.png` - صورة افتراضية للألبومات
- `default_playlist.png` - صورة افتراضية لقوائم التشغيل
- `default_artist.png` - صورة افتراضية للفنانين

## الأيقونات المقترحة

- `music_note.svg` - أيقونة الموسيقى الرئيسية
- `playlist.svg` - أيقونة قائمة التشغيل
- `favorite.svg` - أيقونة المفضلة
- `search.svg` - أيقونة البحث

## ملفات الأنيميشن

- `loading.json` - أنيميشن التحميل
- `music_wave.json` - أنيميشن موجات الموسيقى
- `heart_beat.json` - أنيميشن نبضة القلب للمفضلة

## استخدام الأصول

### في الكود:
```dart
// للصور
Image.asset('assets/images/splash_logo.png')

// للأيقونات
SvgPicture.asset('assets/icons/music_note.svg')

// للأنيميشن
Lottie.asset('assets/animations/loading.json')
```

### في pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - assets/audio/
```

## حقوق الاستخدام

تأكد من أن جميع الأصول المستخدمة:
- لديك حقوق استخدامها
- متوافقة مع رخصة المشروع
- محسنة للأداء (أحجام مناسبة)

## نصائح للأداء

1. **ضغط الصور**: استخدم أدوات ضغط الصور
2. **أحجام متعددة**: وفر أحجام مختلفة للشاشات المختلفة
3. **تنسيقات محسنة**: استخدم WebP للصور، SVG للأيقونات
4. **تحميل كسول**: حمّل الأصول عند الحاجة فقط