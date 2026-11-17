# Expense Manager - Quản lý chi tiêu cá nhân

**Case Study 1: Lập trình di động với Flutter (CTUET)**

- **Họ và tên:** Lê Đức Anh
- **MSSV:** KHMT2411041
- **Email:** ldanhkhmt2411041@student.ctuet.edu.vn
- **Repository:** [https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1](https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1)

---

## 📌 Bảng tổng hợp các buổi thực hành và nhánh GitHub

| Nhánh | Buổi | Nội dung thực hiện | Trạng thái |
|---|---|---|---|
| `buoi1` | Buổi 1 | Khởi tạo dự án Flutter, cấu hình môi trường, đưa code lên GitHub repo. | Hoàn thành |
| `buoi2` | Buổi 2 | Xây dựng giao diện màn hình Chào mừng (Welcome Screen - Expense Manager). | Hoàn thành |
| `buoi3` | Buổi 3 | Xây dựng 2 màn hình Thêm giao dịch (`add_screen.dart`) và Sửa giao dịch (`edit_screen.dart`). | Hoàn thành |
| `buoi4` | Buổi 4 | Xây dựng giao diện màn hình Dashboard quản lý thu chi (`home_screen.dart`). | Hoàn thành |
| `buoi5` | Buổi 5 | Thiết kế và xây dựng cơ sở dữ liệu SQLite cho ứng dụng Expense Manager. | Hoàn thành |
| `buoi6` | Buổi 6 | Hoàn thiện các màn hình thêm, sửa và load thông tin giao dịch lên màn hình Dashboard. | Hoàn thành |
| `buoi7` | Buổi 7 | Nâng cấp mở rộng cơ sở dữ liệu SQLite (Ngân sách, Báo cáo tỷ trọng, Bộ lọc). | Hoàn thành |
| `buoi8` | Buổi 8 | Hoàn thiện toàn bộ ứng dụng (Đa tab, Lịch sử giao dịch, Thống kê, Drawer Menu). | Hoàn thành |

---

## 📱 Các tính năng chính của ứng dụng hoàn thiện (Buổi 8)

1. **Màn hình Chào mừng (Welcome Screen):**
   - Icon ví tiền thương hiệu, thông tin ứng dụng và nút *"Bắt đầu"* chuyển vào Dashboard.
2. **Dashboard Quản lý thu chi (Tab Trang chủ):**
   - Card số dư hiện tại với chế độ ẩn/hiện số tiền an toàn.
   - Thống kê tổng quan: Tổng thu nhập và Tổng chi tiêu.
   - Danh sách các giao dịch gần đây kèm icon, màu sắc và định dạng số tiền VNĐ.
   - Nút bấm *"Xem tất cả"* chuyển nhanh sang tab Lịch sử giao dịch.
   - Vuốt để làm mới (**Pull to Refresh**).
3. **Quản lý giao dịch (Thêm, Sửa, Xóa):**
   - **Thêm giao dịch:** Nút FAB `+` mở màn hình Thêm, nhập số tiền, chọn ngày giao dịch qua DatePicker, chọn danh mục theo loại Thu nhập/Chi tiêu.
   - **Sửa giao dịch:** Nhấn vào bất kỳ giao dịch nào để chỉnh sửa thông tin hoặc xóa với hộp thoại xác nhận.
4. **Lịch sử giao dịch đa năng (Tab Giao dịch):**
   - Ô tìm kiếm thời gian thực theo từ khóa tiêu đề hoặc ghi chú.
   - Bộ lọc theo tab: Tất cả / Chi tiêu / Thu nhập.
   - Thanh cuộn chọn danh mục (Category Chips Filter).
5. **Báo cáo & Thống kê trực quan (Tab Thống kê):**
   - Phân tích dòng tiền thuần và tỷ lệ tiết kiệm.
   - Biểu đồ thanh tỷ trọng cơ cấu chi tiêu theo nhóm danh mục.
   - Danh sách chi tiết tỷ lệ % và số tiền của từng danh mục.
6. **Side Navigation Drawer (Menu bên trái):**
   - Thông tin sinh viên: Lê Đức Anh - MSSV KHMT2411041.
   - Điều hướng nhanh các màn hình.
   - Tính năng **Khôi phục dữ liệu mẫu** (`resetToInitialData`).
   - Hộp thoại Thông tin ứng dụng.
7. **Thông báo (Notification Dialog):**
   - Xem nhanh thông báo hệ thống và lời nhắc tài chính.

---

## 🗂 Cấu trúc mã nguồn hoàn chỉnh
```text
lib/
├── database/
│   └── database_helper.dart        # Quản trị SQLite Singleton, Database v2, CRUD, Thống kê, Ngân sách
├── models/
│   ├── budget_model.dart          # Model ngân sách chi tiêu
│   ├── category_model.dart        # Model danh mục
│   ├── category_stat_model.dart   # Model thống kê cơ cấu chi tiêu
│   └── transaction_model.dart      # Model giao dịch, format VNĐ, icon/màu sắc
├── add_screen.dart                 # Giao diện Thêm giao dịch
├── edit_screen.dart                # Giao diện Sửa & Xóa giao dịch
├── home_screen.dart                # Giao diện Dashboard chính (Tích hợp Drawer, BottomNav)
├── main.dart                       # Entrypoint & Welcome Screen
├── statistics_screen.dart          # Giao diện Báo cáo & Thống kê tỷ trọng chi tiêu
└── transactions_screen.dart        # Giao diện Tìm kiếm & Lọc lịch sử giao dịch
test/
├── database_features_test.dart     # Kiểm thử các tính năng nâng cao
└── transaction_model_test.dart     # Kiểm thử model giao dịch
```
