$ErrorActionPreference = 'Stop'
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Node.js نصب نیست. ابتدا Node.js LTS را نصب کن.' }
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw 'npm در دسترس نیست.' }
Write-Host 'مرحله ۱ از ۴: نصب وابستگی‌ها' -ForegroundColor Cyan
npm install
if (-not (Test-Path '.\android')) {
  Write-Host 'مرحله ۲ از ۴: ساخت پروژه Android' -ForegroundColor Cyan
  npx cap add android
}
Write-Host 'مرحله ۳ از ۴: همگام‌سازی فایل‌ها' -ForegroundColor Cyan
npx cap sync android
Write-Host 'مرحله ۴ از ۴: ساخت APK دیباگ' -ForegroundColor Cyan
Push-Location '.\android'
try { .\gradlew.bat assembleDebug } finally { Pop-Location }
$apk = Join-Path (Get-Location) 'android\app\build\outputs\apk\debug\app-debug.apk'
if (Test-Path $apk) { Write-Host "APK ساخته شد: $apk" -ForegroundColor Green } else { throw 'ساخت تمام شد اما فایل APK پیدا نشد؛ خروجی Gradle را بررسی کن.' }
