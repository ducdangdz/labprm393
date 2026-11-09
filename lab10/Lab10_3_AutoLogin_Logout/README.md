# Lab 10.3 – Auto Login & Logout (Session Management)

## 1. Giới thiệu
Dự án hoàn thiện cơ chế lưu trữ phiên làm việc và tự động đăng nhập (Auto-Login):
- Sử dụng `shared_preferences` để lưu trữ mã `auth_token` và đối tượng `user_data` dạng JSON sau khi đăng nhập thành công.
- **Điều hướng SplashScreen:**
  - Ứng dụng khởi động từ `SplashScreen`.
  - Kiểm tra xem token còn tồn tại trong bộ nhớ cục bộ hay không.
  - Nếu token tồn tại -> Tự động chuyển thẳng tới `HomeScreen` (bỏ qua bước đăng nhập).
  - Nếu chưa có token -> Điều hướng tới `LoginScreen`.
- **Cơ chế Đăng xuất (Logout):**
  - Xóa toàn bộ token và thông tin phiên khỏi `SharedPreferences`.
  - Điều hướng người dùng về `LoginScreen` và xóa stack lịch sử (`pushAndRemoveUntil`).

## 2. Tài khoản kiểm thử
- **Username:** `emilys`
- **Password:** `emilyspass`
*(Hoặc bất kỳ tài khoản hợp lệ nào từ DummyJSON)*

## 3. Các bước kiểm tra tính năng Auto-Login
1. Khởi chạy app và đăng nhập bằng tài khoản `emilys` / `emilyspass`.
2. Ứng dụng chuyển vào `HomeScreen` và báo lưu phiên thành công.
3. Đóng hẳn ứng dụng (Stop app trên Emulator hoặc tắt cửa sổ).
4. Mở lại ứng dụng -> Màn hình `SplashScreen` sẽ tự động phát hiện phiên đăng nhập và đưa người dùng vào `HomeScreen` ngay lập tức!
5. Nhấn nút "Đăng xuất" -> Token bị xóa, mở lại ứng dụng sẽ yêu cầu đăng nhập lại.

## 4. Cách chạy ứng dụng
```bash
cd Lab10_3_AutoLogin_Logout
flutter pub get
flutter run
```
