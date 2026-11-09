# Lab 10 Full – Integrated Application (Authentication, Session Management & Notifications)

## 1. Giới thiệu tổng quan
Dự án hoàn chỉnh tích hợp toàn bộ các tính năng của các phần Lab 10:
1. **Xác thực REST API (DummyJSON):** Đăng nhập với username và password thực tế, xử lý HTTP POST request, loading và lỗi mạng.
2. **Quản lý phiên làm việc (Session Management & Auto-Login):** Lưu trữ token và hồ sơ người dùng trong `shared_preferences`. Tự động khôi phục phiên khi mở lại app qua `SplashScreen`.
3. **Firebase Authentication (Google Sign-In):** Tích hợp đăng nhập một chạm với tài khoản Google, tự động đồng bộ hồ sơ và phiên làm việc.
4. **Thông báo cục bộ (Local Notifications - Chuẩn đầu ra LO7):** Tự động phát thông báo chúc mừng đăng nhập thành công ngay sau khi người dùng xác thực, hỗ trợ kích hoạt thông báo thủ công kèm payload.
5. **Cơ chế Đăng xuất an toàn:** Xóa sạch token, hủy phiên SharedPreferences và đăng xuất khỏi Google/Firebase, chuyển người dùng về màn hình đăng nhập.

## 2. Tài khoản kiểm thử (Test Accounts)
- **Tài khoản REST API (DummyJSON):**
  - Username: `emilys`
  - Password: `emilyspass`
  *(Hoặc tài khoản: `michaelw` / `michaelwpass`)*
- **Tài khoản Google Sign-In:**
  - Sử dụng nút "Đăng nhập với Google" để đăng nhập bằng tài khoản Google thật (hoặc chế độ mô phỏng khi chưa gắn file `google-services.json`).

## 3. Quy trình kiểm tra các tính năng tích hợp
1. **Khởi chạy ứng dụng:** `SplashScreen` hiển thị và kiểm tra token.
2. **Đăng nhập REST API:** Điền `emilys` / `emilyspass` và bấm "Đăng nhập qua REST API".
3. **Kiểm tra thông báo LO7:** Một thông báo xuất hiện trên thanh trạng thái thiết bị chúc mừng đăng nhập.
4. **Kiểm tra Auto-Login:** Đóng hoàn toàn app, mở lại app -> ứng dụng tự chuyển thẳng vào `HomeScreen`.
5. **Kiểm tra Đăng xuất:** Bấm "Đăng xuất và xóa phiên" -> Mở lại app sẽ yêu cầu đăng nhập lại.

## 4. Cách chạy ứng dụng
```bash
cd Lab10_Full
flutter pub get
flutter run
```
