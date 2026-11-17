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
| `buoi7` | Buổi 7 | Nâng cấp và mở rộng cơ sở dữ liệu SQLite (Ngân sách, Thống kê danh mục, Bộ lọc). | Hoàn thành |

---

## Chi tiết Buổi 7: Xây dựng Database nâng cao

1. **Nâng cấp Schema Database:**
   - Phiên bản SQLite Database lên **v2** với hàm di chuyển schema `onUpgradeDB` an toàn.
   - Bổ sung bảng `budgets`: Quản lý hạn mức chi tiêu theo từng danh mục và từng tháng.
   - Bổ sung bảng `app_settings`: Quản lý cấu hình tùy chọn của người dùng.
2. **Các phương thức truy vấn mở rộng:**
   - `searchTransactions(String keyword)`: Tìm kiếm giao dịch nhanh theo tiêu đề hoặc ghi chú.
   - `getFilteredTransactions({int? type, String? category, String? keyword})`: Bộ lọc đa điều kiện.
   - `getCategorySpendingReport()`: Phân tích cơ cấu chi tiêu theo nhóm danh mục, tự động tính tỷ lệ phần trăm (%).
   - `setBudget`, `getAllBudgets`: Thiết lập và tra cứu ngân sách chi tiêu.
   - `resetToInitialData()`: Đặt lại dữ liệu mẫu ban đầu.
3. **Data Models bổ sung:**
   - `CategoryStatModel`: Phục vụ báo cáo tỷ trọng chi tiêu.
   - `BudgetModel`: Phục vụ quản lý ngân sách.
