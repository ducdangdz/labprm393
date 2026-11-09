# PRM LAB 10 – Authentication, Session Management & Notifications

Tập hợp đầy đủ các dự án Flutter theo yêu cầu bài thực hành **Lab 10**. Mỗi phần đều là một dự án chạy độc lập và đã được kiểm tra phân tích tĩnh (`flutter analyze`) đạt 100% chuẩn không lỗi.

---

## 1. Danh sách các dự án nộp bài (Submission Projects)

| Tên dự án | Điểm (%) | Mô tả & Chức năng chính | Gói thư viện chính |
| :--- | :---: | :--- | :--- |
| **`Lab10_1_MockLogin`** | 15% | Đăng nhập mô phỏng backend với Form validation, `Future.delayed`, mock token và Home screen | Flutter SDK |
| **`Lab10_2_RealApiLogin`** | 20% | Đăng nhập qua REST API thực tế với [DummyJSON Auth API](https://dummyjson.com/auth/login), parse avatar & profile | `http` |
| **`Lab10_3_AutoLogin_Logout`** | 25% | Quản lý phiên làm việc, tự động đăng nhập sau khi tắt app qua `SplashScreen`, xóa token khi đăng xuất | `shared_preferences`, `http` |
| **`Lab10_4_FirebaseGoogleSignIn`** | 20% | Đăng nhập một chạm với tài khoản Google qua Firebase Auth (`google_sign_in`, `firebase_auth`) kèm chế độ test | `firebase_core`, `firebase_auth`, `google_sign_in` |
| **`Lab10_5_Notification`** | 10% | Tích hợp thông báo cục bộ (**Chuẩn đầu ra LO7**), xin quyền Android 13+ và kích hoạt thông báo | `flutter_local_notifications` |
| **`Lab10_Full`** | 10% | Ứng dụng tích hợp toàn bộ: SplashScreen routing -> API login / Google Sign-In -> Auto-login -> Local Notification (LO7) | Toàn bộ các thư viện trên |

---

## 2. Tài khoản kiểm thử (Test Accounts)

### Cho Lab 10.1 (Mock):
- **Email:** `admin@example.com`
- **Password:** `123456`

### Cho Lab 10.2, Lab 10.3 và Lab 10 Full (DummyJSON):
- **Tài khoản 1:**
  - Username: `emilys`
  - Password: `emilyspass`
- **Tài khoản 2:**
  - Username: `michaelw`
  - Password: `michaelwpass`

### Cho Lab 10.4 & Lab 10 Full (Google Sign-In):
- Nhấn nút **"Đăng nhập với Google"** để đăng nhập tài khoản Google thực tế hoặc dùng nút thử nghiệm (Simulated Mode).

---

## 3. Các tệp nén đã tạo sẵn để nộp bài
Mỗi dự án đã được nén sẵn thành tệp `.zip` tại thư mục gốc:
- `Lab10_1_MockLogin.zip`
- `Lab10_2_RealApiLogin.zip`
- `Lab10_3_AutoLogin_Logout.zip`
- `Lab10_4_FirebaseGoogleSignIn.zip`
- `Lab10_5_Notification.zip`
- `Lab10_Full.zip`

---

## 4. Hướng dẫn chạy thử từng dự án
Di chuyển vào thư mục dự án tương ứng và chạy:
```bash
flutter pub get
flutter run
```
