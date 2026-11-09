# Lab 8B: Weather Companion App (Ứng dụng Trợ lý Thời tiết & Đời sống)

> **Môn học**: PRM / Lập trình Thiết bị Di động (Flutter)  
> **Chủ đề**: Practical REST API Integration – Turning API Data into Useful Apps  
> **Kịch bản lựa chọn**: **Scenario A – Weather Companion App**  

---

## 1. Giới thiệu & Mục tiêu (App Description)
Ứng dụng **Weather Companion** không chỉ hiển thị các con số thời tiết khô khan mà biến dữ liệu từ REST API thành **những gợi ý thực tế và thiết thực** giúp người dùng trả lời các câu hỏi hàng ngày:
- ☔ **“Hôm nay tôi có cần mang dù / áo mưa không?”**: Hệ thống tự động phân tích mã thời tiết (WMO code), lượng mưa (precipitation) và xác suất mưa để cảnh báo người dùng.
- 👕 **“Nên mặc trang phục gì hôm nay?”**: Căn cứ vào nhiệt độ cảm nhận (*apparent temperature*) để gợi ý áo thun mỏng, áo khoác gió, hoodie hoặc áo ấm chống rét.
- 🏃 **“Hôm nay có thích hợp cho thể thao / hoạt động ngoài trời?”**: Đánh giá dựa trên tốc độ gió, nhiệt độ thực tế và điều kiện mưa để khuyên người dùng có nên chạy bộ, đạp xe hay tập luyện trong nhà.

---

## 2. Công nghệ & REST API sử dụng
- **REST API**: [Open-Meteo API](https://open-meteo.com/) (Hoàn toàn miễn phí, **không yêu cầu API Key**, tốc độ phản hồi cực nhanh, hỗ trợ đầy đủ tiếng Việt).
  - *Dự báo thời tiết*: `https://api.open-meteo.com/v1/forecast`
  - *Tìm kiếm thành phố (Geocoding)*: `https://geocoding-api.open-meteo.com/v1/search`
- **Networking**: Thư viện `http` chính thức của Dart/Flutter (`package:http`).
- **Xử lý bất đồng bộ**: `Future`, `async/await`, `FutureBuilder`, `RefreshIndicator` (kéo để làm mới dữ liệu).
- **Kiến trúc phân tầng (Service Layer Pattern)**:
  - Tách biệt hoàn toàn tầng gọi API (`WeatherService`), tầng dữ liệu (`WeatherModel`, `CityModel`) và tầng giao diện (`screens/`, `widgets/`).
- **Xử lý ngoại lệ**: Xử lý đầy đủ `SocketException` (mất mạng), `TimeoutException` (quá hạn), mã lỗi HTTP kèm nút **"Thử lại ngay" (Retry)**.

---

## 3. Cấu trúc thư mục (Source Code Structure)
```
lib/
├── main.dart                                # Khởi chạy ứng dụng và cấu hình Material 3 Theme
├── models/
│   ├── city_model.dart                      # Model địa điểm, tọa độ, parse JSON Geocoding
│   └── weather_model.dart                   # Model thời tiết chi tiết + logic khuyến nghị thông minh
├── services/
│   └── weather_service.dart                 # Service Layer gọi API Open-Meteo, bắt lỗi mạng
├── screens/
│   ├── weather_home_screen.dart             # Màn hình chính (FutureBuilder, Quick chips, Refresh)
│   └── weather_detail_screen.dart           # Màn hình chi tiết dự báo từng ngày
└── widgets/
    ├── current_weather_card.dart            # Thẻ thời tiết hiện tại (nhiệt độ, độ ẩm, gió, lượng mưa)
    ├── recommendation_card.dart             # Thẻ gợi ý mang dù, trang phục, hoạt động (Điểm nhấn Lab 8B)
    ├── hourly_forecast_view.dart            # Thanh cuộn ngang dự báo 24 giờ tới
    ├── daily_forecast_view.dart             # Danh sách dự báo 7 ngày kèm xác suất mưa
    ├── city_search_dialog.dart              # Hộp thoại tìm kiếm thành phố toàn cầu + gợi ý nhanh
    └── error_view.dart                      # Giao diện thông báo lỗi mạng kèm nút Retry
```

---

## 4. Các trạng thái giao diện (UI States)
1. **Trạng thái đang tải (Loading State)**:
   - Hiển thị `CircularProgressIndicator()` kèm thông báo *"Đang tải dữ liệu thời tiết..."* trong khi `FutureBuilder` chờ dữ liệu từ mạng.
2. **Trạng thái thành công (Success Data State)**:
   - Hiển thị đầy đủ thẻ thời tiết trực quan đổi màu theo ngày/đêm.
   - Thẻ gợi ý thông minh mang dù ☔, trang phục 👕 và hoạt động ngoài trời 🏃.
   - Dự báo 24h và 7 ngày tới.
3. **Trạng thái lỗi (Error State & Retry Action)**:
   - Khi tắt kết nối mạng hoặc nhập sai URL, ứng dụng hiển thị icon cảnh báo, giải thích lỗi thân thiện và nút **"Thử lại ngay"** để tải lại dữ liệu mà không làm sập app.
4. **Trạng thái rỗng / Tìm kiếm (Empty State)**:
   - Khi tìm kiếm một địa điểm không tồn tại, hộp thoại hiển thị thông báo rõ ràng kèm các chip thành phố gợi ý để người dùng chọn nhanh.

---

## 5. Hướng dẫn chạy ứng dụng (How to Run)
Mở terminal tại thư mục dự án (`lab8b/lab8b`) và thực thi:

```bash
# 1. Cài đặt các gói phụ thuộc (nếu cần)
flutter pub get

# 2. Kiểm tra mã nguồn (Đảm bảo 0 lỗi)
flutter analyze

# 3. Chạy kiểm thử tự động
flutter test

# 4. Chạy ứng dụng trên thiết bị (Windows, Chrome, Android, iOS...)
flutter run
```
*(Nếu muốn chạy trực tiếp trên Windows: `flutter run -d windows`, hoặc trên trình duyệt: `flutter run -d chrome`)*
