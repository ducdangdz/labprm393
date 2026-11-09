# Lab 10.5 – Local Notification (MANDATORY – LO7)

## 1. Giới thiệu
Dự án tích hợp thông báo cục bộ (Local Notifications) trên thiết bị di động bằng package `flutter_local_notifications`:
- Đạt chuẩn chuẩn đầu ra **LO7** – integrating notifications in mobile applications.
- Cấu hình quyền hệ thống trong `AndroidManifest.xml`:
  - `android.permission.POST_NOTIFICATIONS` (Android 13+ / API 33+)
  - `android.permission.VIBRATE`
  - `android.permission.RECEIVE_BOOT_COMPLETED`
- Thiết lập kênh thông báo (`NotificationChannel`) với độ ưu tiên cao (`Importance.max`, `Priority.high`).
- Cung cấp phương thức xin cấp quyền runtime đối với Android 13+.
- Trình diễn kích hoạt thông báo tức thì (Instant) và thông báo sau hành động đăng nhập của người dùng kèm payload.

## 2. Các kịch bản kiểm thử (Test Cases)
1. **Kiểm tra cấp quyền:** Bấm biểu tượng làm mới để kiểm tra trạng thái quyền hiển thị thông báo.
2. **Gửi thông báo tức thì:** Bấm "Gửi thông báo tức thì", hệ thống Android sẽ hiện banner thông báo ngay trên thanh trạng thái.
3. **Mô phỏng sau đăng nhập (LO7):** Bấm "Mô phỏng thông báo sau khi đăng nhập", thông báo chào mừng xuất hiện với tên người dùng và payload.
4. **Nhấn vào thông báo:** Khi người dùng nhấn vào thông báo trên thanh thông báo, ứng dụng sẽ mở dialog hiển thị chi tiết Payload.

## 3. Cách chạy ứng dụng
```bash
cd Lab10_5_Notification
flutter pub get
flutter run
```
*(Khuyến nghị chạy trên Android Emulator API 33+ hoặc thiết bị thật để trải nghiệm thông báo).*
