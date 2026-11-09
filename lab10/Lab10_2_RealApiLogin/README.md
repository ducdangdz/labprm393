# Lab 10.2 – Real REST API Login (DummyJSON)

## 1. Giới thiệu
Dự án thực hiện xác thực đăng nhập người dùng thông qua REST API thực tế từ DummyJSON (`https://dummyjson.com/auth/login`):
- Sử dụng package `http` gửi request `POST` với payload JSON (`username`, `password`, `expiresInMins`).
- Parse dữ liệu JSON trả về thành đối tượng `UserModel` (bao gồm `accessToken`, `id`, `username`, `email`, `firstName`, `lastName`, `image`).
- Quản lý trạng thái: hiển thị loading spinner khi đang gọi API, hiển thị thông báo lỗi chi tiết khi sai thông tin hoặc mất mạng.
- Màn hình Home hiển thị đầy đủ thông tin: Ảnh đại diện avatar từ API, họ tên, email, username, token nhận được từ server, cùng nút Đăng xuất.

## 2. Tài khoản kiểm thử (Test Accounts từ DummyJSON)
Hệ thống tích hợp sẵn nút bấm nhanh để điền tài khoản:
- **Tài khoản 1:**
  - Username: `emilys`
  - Password: `emilyspass`
- **Tài khoản 2:**
  - Username: `michaelw`
  - Password: `michaelwpass`

## 3. Cách chạy ứng dụng
```bash
cd Lab10_2_RealApiLogin
flutter pub get
flutter run
```
*(Yêu cầu kết nối Internet để gọi API DummyJSON)*
