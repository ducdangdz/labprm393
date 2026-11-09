# Lab 10.4 – Firebase Authentication (Google Sign-In)

## 1. Giới thiệu
Dự án tích hợp xác thực tài khoản Google sử dụng Firebase Authentication và Google Sign-In:
- Sử dụng các thư viện chính thức: `firebase_core`, `firebase_auth`, `google_sign_in`.
- Triển khai toàn bộ quy trình Google Sign-In:
  1. Kích hoạt `GoogleSignIn.signIn()` mở popup chọn tài khoản Google.
  2. Lấy `idToken` và `accessToken` từ `GoogleSignInAuthentication`.
  3. Tạo chứng chỉ `GoogleAuthProvider.credential(...)`.
  4. Xác thực vào Firebase qua `FirebaseAuth.instance.signInWithCredential(credential)`.
- Hiển thị thông tin hồ sơ: Ảnh đại diện Google (`photoURL`), Họ tên (`displayName`), Email (`email`), Mã định danh (`uid`).
- Tính năng Đăng xuất: gọi đồng thời `FirebaseAuth.instance.signOut()` và `GoogleSignIn().signOut()`.
- Tích hợp thêm chế độ **Simulated Mode** giúp giảng viên và sinh viên kiểm tra giao diện và luồng ứng dụng ngay cả khi chưa kết nối `google-services.json`.

## 2. Hướng dẫn cấu hình Firebase Console (Để chạy thực tế với tài khoản Google thật)
1. Truy cập [Firebase Console](https://console.firebase.google.com) và tạo một dự án mới (ví dụ: `PRM-Lab10`).
2. Vào mục **Build** > **Authentication** > **Sign-in method** > bật nhà cung cấp **Google**.
3. Thêm ứng dụng Android với Package Name: `com.example.lab10_4_firebase_google_sign_in`.
4. Lấy mã SHA-1 của máy tính:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Hoặc:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Nhập mã SHA-1 vào cài đặt ứng dụng Android trên Firebase.
6. Tải tệp `google-services.json` và sao chép vào thư mục `android/app/`.

## 3. Cách chạy ứng dụng
```bash
cd Lab10_4_FirebaseGoogleSignIn
flutter pub get
flutter run
```
