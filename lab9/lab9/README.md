# LAB 9 – Working With Local JSON Storage (Flutter + File Persistence)

Dự án hoàn chỉnh cho **Lab 9 - Lập trình ứng dụng di động (PRM392)**.  
Dự án được triển khai kết hợp 3 bài lab con (**Lab 9.1**, **Lab 9.2**, **Lab 9.3**) vào một ứng dụng duy nhất có thanh điều hướng chuyển tab mượt mà.

---

## 📁 Cấu trúc Thư mục (Project Architecture)

```text
lab9/
├── assets/
│   └── data/
│       └── students.json           # File JSON tĩnh nhúng trong assets (Lab 9.1)
├── lib/
│   ├── models/
│   │   ├── student_model.dart      # Model sinh viên cho Lab 9.1 (fromJson / toJson)
│   │   ├── note_item.dart          # Model ghi chú cho Lab 9.2
│   │   └── product_item.dart       # Model sản phẩm cho Mini DB Lab 9.3 (CRUD)
│   ├── services/
│   │   └── storage_service.dart    # Dịch vụ đọc/ghi file JSON cục bộ (path_provider)
│   ├── screens/
│   │   ├── lab9_1_screen.dart      # Giao diện Lab 9.1: Đọc JSON từ Assets
│   │   ├── lab9_2_screen.dart      # Giao diện Lab 9.2: Lưu & Tải JSON từ bộ nhớ máy
│   │   └── lab9_3_screen.dart      # Giao diện Lab 9.3: Mini Database CRUD + Search
│   └── main.dart                   # NavigationBar chuyển đổi giữa 3 bài Lab
├── test/
│   └── widget_test.dart            # Unit test & Widget test (All tests passed)
└── pubspec.yaml                    # Đã cấu hình path_provider và assets/data/
```

---

## 🚀 Tính năng chi tiết từng bài Lab

### 1. Lab 9.1 – Đọc JSON từ Assets (`lab9_1_screen.dart`)
- **Nguồn dữ liệu:** `assets/data/students.json` được khai báo trong `pubspec.yaml`.
- **Phương thức tải:** Dùng `rootBundle.loadString('assets/data/students.json')`.
- **Giải mã:** Dùng `jsonDecode()` từ thư viện `dart:convert`.
- **Hiển thị:** Dùng `ListView.builder` hiển thị danh sách sinh viên với đầy đủ thông tin:
  - Avatar ký tự đầu tên sinh viên (màu sắc phân loại theo điểm GPA).
  - Tên sinh viên (Field 1).
  - Email, chuyên ngành (Major), số điện thoại (Field 2+).
  - Huy hiệu GPA.
- **Tính năng nâng cao (Bonus):**
  - Thanh tìm kiếm lọc sinh viên theo tên/email/chuyên ngành.
  - Xem chi tiết sinh viên khi chạm vào từng dòng (`showModalBottomSheet`).
  - Nút xem chuỗi JSON gốc trực tiếp trên app (`View Raw JSON`).
  - Kéo để làm mới (`RefreshIndicator`).

---

### 2. Lab 9.2 – Lưu & Tải JSON từ bộ nhớ máy (`lab9_2_screen.dart`)
- **Thư viện:** Sử dụng `path_provider` (`getApplicationDocumentsDirectory`) để lấy thư mục tài liệu an toàn của ứng dụng.
- **Tên file lưu:** `lab9_2_notes.json`.
- **Tính năng:**
  - Tải dữ liệu tự động khi khởi động (`initState` -> `readNotes()`).
  - Tự động tạo dữ liệu mẫu nếu file chưa tồn tại.
  - Form thêm ghi chú mới (Tiêu đề, Nội dung, Thẻ phân loại: Study, Work, Personal, Important).
  - **Nút "Save to File":** Lưu danh sách vào file JSON cục bộ với định dạng thụt lề 2 khoảng trắng (dễ đọc).
  - **Nút "Reload from Disk":** Nạp lại dữ liệu từ ổ đĩa để chứng minh tính bền vững (Persistence across app restarts).
  - Thông báo `SnackBar` màu xanh xác nhận lưu thành công.
  - Nút "Clear Storage" và nút xóa từng item (kèm tính năng Hoàn tác - Undo).
  - Nút xem nội dung file JSON thực tế và đường dẫn đầy đủ trên máy.

---

### 3. Lab 9.3 – JSON CRUD Mini Database (`lab9_3_screen.dart`)
- **Tên file cơ sở dữ liệu:** `lab9_3_database.json`.
- **Đầy đủ 4 thao tác CRUD:**
  - **Create (Thêm mới):** Hộp thoại thêm sản phẩm với ID tự tăng (`max(id) + 1`), kiểm tra tính hợp lệ dữ liệu.
  - **Read (Đọc & Hiển thị):** Hiển thị danh sách sản phẩm đẹp mắt với Card, giá tiền, số lượng tồn kho, danh mục, thời gian cập nhật.
  - **Update (Sửa):** Nhấn nút Edit trên từng sản phẩm để mở hộp thoại cập nhật thông tin và lưu lại.
  - **Delete (Xóa):** Nhấn nút Delete sẽ hiện **Hộp thoại xác nhận (Confirm Dialog)** trước khi xóa vĩnh viễn (kèm nút Hoàn tác `Undo` trên SnackBar).
- **Auto-Save:** Tự động ghi vào file JSON ngay lập tức sau mỗi thao tác Thêm, Sửa, Xóa!
- **Search & Filter:**
  - Thanh tìm kiếm thời gian thực theo tên sản phẩm, danh mục, mô tả.
  - Hàng Chips phân loại danh mục (All, Laptop, Smartphone, Audio, Accessories, Monitor...).
- **Thống kê:** Thanh thống kê tổng số lượng sản phẩm và tổng giá trị kho hàng ($).
- **Reset to Defaults:** Cho phép khôi phục lại dữ liệu mẫu bất kỳ lúc nào qua menu trên AppBar.

---

## 🛠️ Hướng dẫn Chạy Ứng Dụng

### Cách 1: Chạy bằng Terminal
```bash
cd D:\PRM\PRMLAB\lab9\lab9
flutter run
```

### Cách 2: Chạy kiểm thử tự động (Unit / Widget Test)
```bash
cd D:\PRM\PRMLAB\lab9\lab9
flutter test
```
*Kết quả:* Tất cả 5 bộ test đều vượt qua (`All tests passed!`).

---

## 📸 Hướng dẫn Chụp Ảnh Báo Cáo (Screenshots Deliverables)
Khi nộp bài theo yêu cầu mục 5 của đề bài:
1. **Lab 9.1:** Chụp màn hình tab "9.1 Assets JSON" hiển thị danh sách sinh viên được nạp từ file JSON assets. (Có thể bấm nút icon code trên góc phải để chụp bảng Raw JSON).
2. **Lab 9.2:** Chụp màn hình tab "9.2 Local Storage" khi nhập ghi chú mới và bấm "Save to File" (hiện SnackBar xác nhận thành công và đường dẫn file lưu).
3. **Lab 9.3:** Chụp màn hình tab "9.3 CRUD Mini DB" khi tìm kiếm sản phẩm, mở hộp thoại Thêm/Sửa hoặc Hộp thoại xác nhận Xóa sản phẩm.
