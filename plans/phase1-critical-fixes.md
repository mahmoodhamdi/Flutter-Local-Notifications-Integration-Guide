# المرحلة 1: إصلاح الأخطاء الحرجة

## الحالة: ✅ مكتمل

## الهدف
إصلاح جميع الأخطاء الحرجة في المشروع لضمان استقراره وعمله بشكل صحيح على Android و iOS.

---

## المهام

### 1. إصلاح تسريب الذاكرة (Memory Leaks)

#### في `notification_helper.dart`:
- إضافة method لإغلاق StreamController
- تحسين إدارة الـ Stream

#### في `home_page.dart`:
- حفظ StreamSubscription في متغير
- إلغاء الـ subscription في dispose()

### 2. إضافة دعم iOS

#### في `notification_helper.dart`:
- إضافة DarwinInitializationSettings
- إضافة DarwinNotificationDetails للإشعارات

#### في `ios/Runner/AppDelegate.swift`:
- تسجيل الإشعارات مع iOS

### 3. إضافة طلب الأذونات

#### إنشاء `permission_helper.dart`:
- طلب إذن POST_NOTIFICATIONS لـ Android 13+
- طلب إذن الإشعارات لـ iOS
- طلب إذن SCHEDULE_EXACT_ALARM

#### في `home_page.dart`:
- طلب الأذونات عند بدء التطبيق

### 4. إصلاح اسم ملف الصوت

#### في `notification_helper.dart`:
- إزالة `.mp3` من اسم الملف في RawResourceAndroidNotificationSound

---

## الملفات المتأثرة

- `lib/helpers/notification_helper.dart`
- `lib/helpers/permission_helper.dart` (جديد)
- `lib/pages/home_page.dart`
- `lib/main.dart`
- `ios/Runner/AppDelegate.swift`
- `pubspec.yaml` (إضافة permission_handler)

---

## طريقة التنفيذ

1. تحديث pubspec.yaml لإضافة permission_handler
2. إنشاء permission_helper.dart
3. تحديث notification_helper.dart
4. تحديث home_page.dart
5. تحديث AppDelegate.swift
6. تشغيل الاختبارات والتحقق

---

## النتيجة المتوقعة

- لا يوجد تسريب للذاكرة
- التطبيق يعمل على iOS
- الأذونات تُطلب بشكل صحيح
- الصوت المخصص يعمل
