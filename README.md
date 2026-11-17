# Expense Manager - Quản lý chi tiêu cá nhân

**Case Study 1: Lập trình di động với Flutter**

- **Họ và tên:** Lê Đức Anh
- **MSSV:** KHMT2411041
- **Email:** ldanhkhmt2411041@student.ctuet.edu.vn
- **Repository:** [https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1](https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1)

---

## Danh sách nhánh và tiến độ các buổi thực hành

| Nhánh | Buổi | Nội dung thực hiện | Trạng thái |
|---|---|---|---|
| `buoi1` | Buổi 1 | Khởi tạo dự án Flutter, cấu hình môi trường, đưa code lên GitHub repo. | Hoàn thành |
| `buoi2` | Buổi 2 | Xây dựng giao diện màn hình Chào mừng (Welcome Screen - Expense Manager). | Hoàn thành |
| `buoi3` | Buổi 3 | Xây dựng 2 màn hình Thêm giao dịch (`add_screen.dart`) và Sửa giao dịch (`edit_screen.dart`). | Hoàn thành |
| `buoi4` | Buổi 4 | Xây dựng giao diện màn hình Dashboard quản lý thu chi (`home_screen.dart`). | Hoàn thành |
| `buoi5` | Buổi 5 | Thiết kế và xây dựng cơ sở dữ liệu SQLite cho ứng dụng Expense Manager. | Hoàn thành |
| `buoi6` | Buổi 6 | Hoàn thiện các màn hình thêm, sửa và load thông tin giao dịch lên màn hình Dashboard. | Hoàn thành |

---

## Chi tiết Buổi 6: Hoàn thiện Thêm, Sửa và Nạp dữ liệu Dashboard

### 1. Luồng hoạt động hoàn thiện (Full Flow)
1. **Welcome Screen (`main.dart`):** Bấm nút *"Bắt đầu"* để điều hướng vào Dashboard chính.
2. **Dashboard (`home_screen.dart`):**
   - Tự động nạp dữ liệu động thời gian thực từ SQLite `DatabaseHelper`.
   - Tính toán và hiển thị chính xác **Số dư hiện tại**, **Tổng thu nhập**, **Tổng chi tiêu**.
   - Hỗ trợ ẩn/hiện số dư tài khoản khi nhấn vào icon mắt.
   - Hiển thị danh sách các giao dịch gần đây kèm icon, màu sắc và định dạng số tiền (+/- VNĐ).
   - Hỗ trợ vuốt xuống để làm mới dữ liệu (**Pull to Refresh**).
3. **Thêm giao dịch (`add_screen.dart`):**
   - Nhấn nút `+` (FloatingActionButton) ở Dashboard để mở màn hình Thêm.
   - Nhập thông tin, chọn ngày bằng `DatePicker`, chọn danh mục tương ứng theo loại Chi tiêu/Thu nhập.
   - Bấm *"Lưu"* để ghi vào SQLite qua `insertTransaction` và tự động quay về Dashboard cập nhật số liệu.
4. **Sửa / Xóa giao dịch (`edit_screen.dart`):**
   - Nhấn vào bất kỳ giao dịch nào trong danh sách Dashboard để mở màn hình Sửa với dữ liệu được điền sẵn.
   - Cho phép chỉnh sửa thông tin và bấm *"Lưu"* để cập nhật qua `updateTransaction`.
   - Hỗ trợ icon *"Thùng rác"* trên AppBar để xóa giao dịch qua `deleteTransaction` với hộp thoại xác nhận an toàn.
   - Tự động quay về Dashboard và làm mới số dư cùng danh sách giao dịch.

---

## Cấu trúc mã nguồn trong `lib/`
```text
lib/
├── database/
│   └── database_helper.dart      # Quản trị SQLite Singleton, tạo bảng, CRUD, seeding, thống kê
├── models/
│   ├── category_model.dart       # Model danh mục, toMap(), fromMap()
│   └── transaction_model.dart    # Model giao dịch, format tiền tệ, mapping icon/màu sắc
├── add_screen.dart               # Giao diện Thêm giao dịch (kết nối insert SQLite)
├── edit_screen.dart              # Giao diện Sửa & Xóa giao dịch (kết nối update/delete SQLite)
├── home_screen.dart              # Giao diện Dashboard (load động số dư, tổng thu, tổng chi, danh sách)
└── main.dart                     # Giao diện Chào mừng (WelcomeScreen) & Điều hướng sang Dashboard
```
