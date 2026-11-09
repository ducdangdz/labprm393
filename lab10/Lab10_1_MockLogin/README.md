# Lab 10.1 – Mock Login (Backend Simulation)

## 1. Giới thiệu
Dự án mô phỏng quá trình đăng nhập qua backend giả lập:
- Giao diện đăng nhập chuẩn Material 3 với Form Validation (kiểm tra định dạng email và độ dài mật khẩu).
- Giả lập độ trễ mạng bằng `Future.delayed`.
- Xử lý trạng thái loading và phản hồi (thành công chuyển sang Home, thất bại hiển thị SnackBar).
- Cung cấp token phiên làm việc giả lập trên màn hình Home và tính năng Đăng xuất.

## 2. Tài khoản kiểm thử (Test Account)
- **Email:** `admin@example.com`
- **Mật khẩu:** `123456`

*(Nếu nhập sai tài khoản hoặc mật khẩu, ứng dụng sẽ hiển thị thông báo lỗi rõ ràng).*

## 3. Cách chạy ứng dụng
```bash
cd Lab10_1_MockLogin
flutter pub get
flutter run
```
