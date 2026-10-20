# روزیار (RoozYar) — نسخه اولیه قابل اجرا

برنامه فارسی RTL با ظاهر تیره، مناسب گوشی اندروید. قابلیت‌ها:
- کارها و عادت‌های روزانه، هفتگی و یک‌باره؛ امکان افزودن، ویرایش، غیرفعال کردن و ثبت انجام
- ثبت مصرف آب با هدف قابل تنظیم
- تقویم ماهانه و انتخاب روز
- ثبت مدت مطالعه، درس، تعداد تست و پاسخ درست
- دفتر گزارش کارآموزی با زمان، نتیجه و وضعیت؛ خروجی متنی/JSON
- هدف‌های بلندمدت با درصد پیشرفت
- پشتیبان‌گیری و بازیابی JSON
- آماده اتصال به Firebase Authentication + Cloud Firestore؛ اطلاعات به‌صورت پیش‌فرض محلی می‌ماند تا تنظیم Firebase وارد و حساب متصل شود

## پیش‌نیاز ساخت APK
- Node.js LTS
- Android Studio به‌همراه Android SDK و JDK مورد پشتیبانی نسخه Capacitor
- اتصال اینترنت برای نصب وابستگی‌ها

## ساخت APK در ویندوز
1. فایل ZIP را استخراج کن.
2. در پوشه `RoozYar` ترمینال باز کن.
3. اجرا کن:
   ```powershell
   npm install
   npx cap add android
   npx cap sync android
   npx cap open android
   ```
4. در Android Studio صبر کن Gradle Sync تمام شود. برای نصب روی گوشی USB debugging را فعال کن و Run بزن.
5. برای ساخت فایل APK از منوی **Build > Build Bundle(s) / APK(s) > Build APK(s)** استفاده کن. معمولاً فایل در `android/app/build/outputs/apk/debug/app-debug.apk` ساخته می‌شود.

این محیط فعلی Android SDK/Gradle را ندارد، بنابراین APK از پیش ساخته‌شده در این بسته وجود ندارد؛ سورس پروژه آماده است و باید روی محیط دارای Android SDK ساخته شود. فایل‌های رابط کاربری داخل پوشه `www` قرار دارند و Capacitor همین پوشه را در اپ اندروید قرار می‌دهد.

## فعال‌سازی همگام‌سازی ابری
1. در Firebase Console یک پروژه بساز.
2. از بخش Authentication، روش Email/Password را فعال کن.
3. در Firestore Database دیتابیس بساز.
4. یک Web App به پروژه اضافه کن و `apiKey`, `authDomain`, `projectId`, `appId` را بردار.
5. در برنامه، تنظیمات > Firebase را باز کن، این مقادیر را وارد کن و ایمیل/رمز بساز یا وارد شو.
6. این قوانین Firestore را تنظیم کن تا هر حساب فقط به سند خودش دسترسی داشته باشد:
   ```text
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/data/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
7. برای استفاده واقعی، قوانین را در محیط Firebase بررسی کن و در کنسول برای Authentication و Firestore محدودیت‌های مناسب بگذار. رمز کاربر در این برنامه ذخیره نمی‌شود.

## نکته‌ها
- Google Fonts برای فونت Vazirmatn به اینترنت نیاز دارد؛ در صورت قطع اینترنت فونت جایگزین استفاده می‌شود.
- PWA/service worker برای اجرای مرورگری وجود دارد؛ قابلیت APK از طریق Capacitor است.
- این یک نسخه اولیه است؛ اعلان‌های زمان‌بندی‌شده اندروید و تقویم جلالی تعاملی در نسخه بعدی قابل اضافه شدن‌اند. تاریخ‌های ذخیره‌شده در فرم‌ها از تاریخ استاندارد دستگاه استفاده می‌کنند.

### روش سریع ساخت APK با اسکریپت ویندوز
در PowerShell داخل پوشه پروژه اجرا کن:
```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build-apk.ps1
```
اگر ساخت به‌خاطر SDK یا JDK متوقف شد، Android Studio را نصب/باز کن و Android SDK و JDK مورد نیاز Gradle را تنظیم کن، سپس دوباره اسکریپت را اجرا کن.
