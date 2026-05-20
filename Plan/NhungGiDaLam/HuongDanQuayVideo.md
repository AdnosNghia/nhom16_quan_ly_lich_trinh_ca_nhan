# Hướng Dẫn Quay Video Demo — Schedulr App

> **Mục tiêu**: Demo đầy đủ **tất cả chức năng** của ứng dụng Quản Lý Lịch Trình Cá Nhân (Schedulr) theo trình tự hợp lý.

---

## Chuẩn bị trước khi quay

1. **Mở ứng dụng** trên emulator/thiết bị thật (đã chạy `flutter run`)
2. **Đảm bảo** database còn trống (chưa có tài khoản, chưa có sự kiện)
3. **Mở công cụ quay màn hình** (OBS / Android Studio screen record / iOS QuickTime)
4. **Nội dung cần có trên tay**: danh sách tài khoản demo để đăng ký (VD: `demo@test.com` / `123456`)

---

## Demo Flow — Từng bước chi tiết

### Phần 1: Splash Screen & Onboarding

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 1.1 | Mở ứng dụng | **Splash Screen**: Nền gradient tím, icon lịch trắng, chữ "SCHEDULR", thanh loading, dòng chữ "Đang khởi tạo không gian làm việc..." | "Đây là màn hình Splash — ứng dụng đang kiểm tra trạng thái đăng nhập và khởi tạo dữ liệu." |
| 1.2 | Chờ 2 giây tự động chuyển | **Onboarding Slide 1**: Icon `auto_awesome`, tiêu đề "Lập lịch thông minh", mô tả "Quản lý công việc hàng ngày", nút "Bỏ qua" (góc phải), nút "Tiếp theo" (dưới), chấm tròn page indicator | "Sau 2 giây, ứng dụng tự động chuyển đến Onboarding vì chưa có tài khoản. Đây là slide giới thiệu đầu tiên về tính năng lập lịch." |
| 1.3 | Nhấn **"Tiếp theo"** | **Onboarding Slide 2**: Icon `notifications_active`, tiêu đề "Nhắc nhở thông minh" | "Slide thứ hai giới thiệu về tính năng nhắc nhở." |
| 1.4 | Nhấn **"Tiếp theo"** | **Onboarding Slide 3**: Icon `analytics`, tiêu đề "Phân tích hiệu suất", nút đổi thành **"Bắt đầu"** | "Slide cuối cùng về thống kê hiệu suất. Nhấn Bắt đầu để đến màn hình Đăng nhập." |
| 1.5 | Nhấn **"Bắt đầu"** | Chuyển đến **Login Screen** | — |

> **Ghi chú**: Có thể dùng nút "Bỏ qua" để tắt nhanh Onboarding

---

### Phần 2: Đăng ký tài khoản (Register)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 2.1 | Nhấn link **"Đăng ký"** phía dưới (cạnh "Chưa có tài khoản?") | Chuyển đến **Register Screen**: icon lịch, "Schedulr", "Lập kế hoạch mỗi ngày, đơn giản hóa cuộc sống" | "Tôi sẽ đăng ký tài khoản mới trước." |
| 2.2 | Nhập: **Họ và tên** = `Nguyễn Văn A` | TextField "Họ và tên" | — |
| 2.3 | Nhập: **Email** = `demo@test.com` | TextField "Địa chỉ Email" | — |
| 2.4 | Nhập: **Mật khẩu** = `123456` | TextField "Mật khẩu" (có icon mắt để ẩn/hiện) | — |
| 2.5 | Nhập: **Xác nhận mật khẩu** = `123456` | TextField "Xác nhận mật khẩu" | — |
| 2.6 | Nhấn nút **"Đăng Ký"** (có icon mũi tên) | Hiện loading "Đang xử lý...", nếu thành công → chuyển đến Dashboard | "Sau khi điền đầy đủ thông tin, nhấn Đăng Ký. Hệ thống sẽ tạo tài khoản và tự động đăng nhập." |

> **Test validation**: Thử bỏ trống / email không có @ / mật khẩu < 6 ký tự / xác nhận sai → sẽ thấy lỗi tương ứng

---

### Phần 3: Dashboard (Trang chủ)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 3.1 | Quan sát màn hình (tự động sau đăng ký) | **Dashboard**: Header avatar + "Chào buổi sáng, Nguyễn Văn A" + icon chuông thông báo | "Đây là màn hình Dashboard — trung tâm điều khiển chính của ứng dụng." |
| 3.2 | Scroll ngang **Week Strip** | Dải 7 ngày: Thứ 2 → Chủ nhật, ngày hôm nay được highlight, có nút "Xem Lịch" | "Week Strip hiển thị 7 ngày trong tuần, có thể scroll và chọn ngày. Ngày hiện tại được tô màu chủ đạo." |
| 3.3 | Quan sát **Progress Card** | Card "Tiến độ hôm nay" với vòng tròn phần trăm, dòng chữ "Bạn đang làm rất tốt! Sắp hoàn thành rồi." | "Card Tiến độ hiển thị phần trăm hoàn thành công việc hôm nay — dữ liệu được truy vấn trực tiếp từ database." |
| 3.4 | Quan sát **Priority Tasks** | Danh sách "Công việc ưu tiên" — hiện tại trống (chưa có sự kiện) | "Khu vực Công việc ưu tiên sẽ hiển thị tối đa 3 sự kiện sắp diễn ra nhất." |
| 3.5 | Quan sát **Upcoming Events** | "Sự kiện sắp tới" — hiện tại trống | "Sự kiện sắp tới tương tự, cũng hiển thị tối đa 3 sự kiện." |
| 3.6 | Nhấn nút **"+" FAB** (góc dưới phải) | Chuyển đến **Add Event Screen** | — |
| 3.7 | Nhấn nút **✕ (close)** hoặc back | Quay lại Dashboard | — |

---

### Phần 4: Thêm sự kiện (Add Event)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 4.1 | Nhấn nút **"+" FAB** trên Dashboard (hoặc Calendar) | **Add Event Screen**: Header "Thêm Sự Kiện", nút Close (✕) | "Tôi sẽ tạo một sự kiện mới để demo luồng thêm sự kiện." |
| 4.2 | Nhập **Tiêu đề**: `Họp nhóm đồ án` | TextField lớn với hint "Tên sự kiện của bạn..." | — |
| 4.3 | Nhấn vào card **"Bắt đầu"** (ngày & giờ) | Mở **DatePicker**. Chọn ngày hôm nay + 1 giờ | "Chọn ngày và giờ bắt đầu cho sự kiện." |
| 4.4 | Nhấn vào card **"Kết thúc"** | Mở **DatePicker + TimePicker**. Chọn ngày hôm nay + 2 giờ sau | "Chọn ngày và giờ kết thúc." |
| 4.5 | Bật **Switch "Cả ngày"** | Card "Cả ngày" với Switch (nếu muốn sự kiện trọn ngày) | "Có thể bật chế độ Cả ngày nếu sự kiện kéo dài cả ngày." (Có thể quay hoặc không). |
| 4.6 | Nhấn chọn **Danh mục**: chọn "Công việc" | Các ChoiceChip: "Công việc" (tím), "Học tập" (nâu), "Cá nhân" (đỏ), "Sức khỏe" (xanh lá). Mỗi chip có chấm tròn màu tương ứng. | "Sự kiện có thể gắn danh mục — 4 danh mục mặc định được seed từ database." |
| 4.7 | Nhấn chọn **Nhắc nhở**: chọn "15 phút" | 3 lựa chọn: 5 phút, 15 phút, 30 phút (highlight khi chọn) | "Chọn mốc nhắc nhở trước sự kiện." |
| 4.8 | Nhấn **"Thêm việc"** trong mục "Công Việc Con" | Xuất hiện TextField + nút `+` | "Có thể thêm các subtask con cho sự kiện." |
| 4.9 | Nhập: `Soạn tài liệu` + nhấn `+` | Subtask xuất hiện với checkbox + title + nút xoá | — |
| 4.10 | Nhập tiếp: `Chuẩn bị slide` + nhấn `+` | Subtask thứ hai | — |
| 4.11 | Nhấn nút **"Lưu Sự Kiện"** (thanh dưới cùng) | Hiện loading, sau đó pop về màn hình trước | "Nhấn Lưu — sự kiện được insert vào SQLite database và tự động cập nhật lên giao diện." |
| 4.12 | Tạo thêm **1 sự kiện khác** (VD: `Tập thể dục`, danh mục Sức khỏe, sáng mai) | Lặp lại các bước 4.1 → 4.11 | "Tôi sẽ tạo thêm một sự kiện nữa để thấy dữ liệu trên Dashboard và Calendar." |

---

### Phần 5: Calendar (Lịch)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 5.1 | Nhấn tab **"Lịch"** trên Bottom Nav (icon thứ 2) | **Calendar Screen**: Header avatar + "Schedulr" + chuông. Phần trên: Segmented control "Tháng / Tuần / Ngày" (chỉ Tháng hoạt động) | "Chuyển sang tab Lịch để xem sự kiện dưới dạng lưới tháng." |
| 5.2 | Quan sát **Lưới tháng** | Lưới 7 cột (T2 → CN). Các ngày có sự kiện hiển thị chấm tròn màu (tương ứng danh mục). Ngày hôm nay in đậm màu chủ đạo. | "Lưới tháng hiển thị toàn bộ các ngày. Ngày nào có chấm tròn nghĩa là có sự kiện — màu sắc tương ứng với danh mục." |
| 5.3 | Nhấn nút **`<`** (trái) | Chuyển sang tháng trước | "Có thể điều hướng qua các tháng bằng nút mũi tên." |
| 5.4 | Nhấn nút **`>`** (phải) | Quay lại tháng hiện tại | — |
| 5.5 | **Chọn 1 ngày có sự kiện** (có chấm tròn) | Phần **Agenda** (bên dưới) cập nhật: dòng "EEEE, ngày d tháng M" (VD: "Thứ Hai, ngày 18 tháng 5"), số lượng "1 Sự kiện đã được lập lịch" | "Khi chọn một ngày, Agenda bên dưới hiển thị danh sách sự kiện của ngày đó, kèm định dạng ngày tháng tiếng Việt." |
| 5.6 | Quan sát **Card sự kiện** trong Agenda | Card có: thanh màu trái (theo danh mục), title, thời gian (VD: 10:00 - 11:00), nút thùng rác (xoá) | "Mỗi sự kiện trong Agenda có thanh màu, tiêu đề, khung giờ và nút xoá." |
| 5.7 | Nhấn nút **thùng rác** trên 1 sự kiện | Hiện **Dialog xác nhận**: "Bạn có chắc muốn xoá sự kiện này?" + "Hủy" / "Xoá" | — |
| 5.8 | Nhấn **"Hủy"** | Dialog đóng, sự kiện còn nguyên | "Có thể huỷ nếu không muốn xoá." |
| 5.9 | Nhấn **thùng rác** + **"Xoá"** | Sự kiện bị xoá khỏi DB, Agenda và lưới tháng cập nhật ngay lập tức | "Hoặc xác nhận xoá — dữ liệu được xoá khỏi database và giao diện tự động refresh." |
| 5.10 | Nhấn nút **"+" (FAB nhỏ)** trong Agenda | Chuyển đến **Add Event Screen** | "Có thể thêm sự kiện trực tiếp từ Calendar." |

---

### Phần 6: Tasks (Eisenhower Matrix)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 6.1 | Nhấn tab **"Công việc"** trên Bottom Nav (icon thứ 3) | **Tasks Screen**: Header + "Ma trận Eisenhower", subtitle "Ưu tiên các công việc dựa trên mức độ khẩn cấp và quan trọng." | "Tab Công việc sử dụng mô hình Eisenhower Matrix với 4 nhóm." |
| 6.2 | Quan sát 4 **Quadrants** | 1. **Làm ngay** (tím, icon `bolt`) — Gấp & Quan trọng | 2. **Lên lịch** (hồng, icon `calendar_month`) — Không gấp & Quan trọng | 3. **Ủy thác** (cam, icon `group`) — Gấp & Không quan trọng | 4. **Loại bỏ** (xám, icon `delete`, gạch ngang) — Không gấp & Không quan trọng | "4 ô tương ứng với 4 chiến lược: Làm ngay, Lên lịch, Ủy thác, Loại bỏ." |
| 6.3 | Nhấn vào header **"Làm ngay"** (hoặc nút `+` trong ô) | Mở **Dialog thêm task**: TextField + "Huỷ" / "Thêm" | "Thêm task mới — nhập tên và nhấn Thêm." |
| 6.4 | Nhập `Báo cáo tuần` + nhấn **"Thêm"** | Task xuất hiện trong ô Làm ngay, kèm checkbox và nút X | — |
| 6.5 | Thêm thêm 1 task vào **"Lên lịch"**: `Đọc sách` | Tương tự bước 6.3-6.4, nhưng chọn header "Lên lịch" | — |
| 6.6 | **Check checkbox** của task "Báo cáo tuần" | Task được đánh dấu hoàn thành (gạch ngang chữ) | "Có thể đánh dấu hoàn thành bằng checkbox." |
| 6.7 | Nhấn nút **X** trên task "Đọc sách" | Task bị xoá khỏi ô và database | "Và có thể xoá task không cần thiết." |

> **Lưu ý**: Task trong ô "Loại bỏ" luôn hiển thị gạch ngang vì đó là nhóm "không quan trọng, không gấp" — nên loại bỏ.

---

### Phần 7: Analytics (Thống kê)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 7.1 | Nhấn tab **"Thống kê"** trên Bottom Nav (icon thứ 4) | **Analytics Screen**: Header + Weekly Overview | "Tab Thống kê tổng hợp hiệu suất làm việc của bạn." |
| 7.2 | Quan sát **Weekly Overview** | Banner tím: "Tiến độ tuyệt vời!", "Bạn đã hoàn thành X trên Y công việc." | "Tổng quan tuần này — dữ liệu được tính từ số task đã hoàn thành trong 7 ngày qua." |
| 7.3 | Quan sát **Productivity Score** | Card "Điểm hiệu suất" + thanh progress tuyến tính /100 | "Điểm hiệu suất được tính dựa trên tỷ lệ hoàn thành." |
| 7.4 | Quan sát **Bar Chart** | "Hoàn thành công việc" + badge "Tuần này". 7 cột dọc (T-H-B-N-S-B-C) với chiều cao tương ứng số task hoàn thành mỗi ngày. | "Biểu đồ cột 7 ngày — mỗi cột là số task hoàn thành của ngày đó." |
| 7.5 | Quan sát **Time Distribution** | Biểu đồ tròn (Donut) vẽ bằng CustomPainter với 3 phần: Công việc 45%, Sức khỏe 25%, Cá nhân 20%. Legend phía dưới. | "Biểu đồ tròn phân bổ thời gian theo danh mục — được vẽ bằng CustomPainter." |
| 7.6 | Quan sát **Focus Stats** | 3 card nhỏ: "Tổng sự kiện", "Đã hoàn thành", "Còn lại" | "Thống kê nhanh số liệu sự kiện từ EventProvider." |
| 7.7 | Quan sát **Activity Heatmap** | "Hoạt động 30 ngày" với legend gradient từ "Ít" → "Nhiều" | "Heatmap trực quan hoá mức độ hoạt động trong 30 ngày." |
| 7.8 | Quan sát **Smart Suggestions** | 2 gợi ý: "Đỉnh cao buổi sáng" (40% trước 11h) + "Tiến độ tổng thể" | "Gợi ý thông minh dựa trên dữ liệu thực tế — giúp người dùng tối ưu lịch trình." |

---

### Phần 8: Settings (Cài đặt)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 8.1 | Nhấn tab **"Cài đặt"** trên Bottom Nav (icon thứ 5) | **Settings Screen**: Header + "Cài đặt" + description | "Tab cuối cùng là Cài đặt — quản lý tài khoản và tuỳ chỉnh ứng dụng." |
| 8.2 | Quan sát **Profile Card** | Avatar (có icon edit overlay), tên "Nguyễn Văn A", email "demo@test.com", chip "Thành viên Pro" | "Thông tin cá nhân được đồng bộ từ AuthProvider." |
| 8.3 | Nhấn **"Thông tin tài khoản"** | Chuyển đến **Account Info Screen** | — |

#### 8a. Account Info

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 8a.1 | Quan sát **Profile section** | Avatar lớn + icon camera, tên "Nguyễn Minh Tuấn" (dữ liệu mẫu), "Sinh viên năm 3 - Đại học Bách Khoa" | "Màn hình thông tin cá nhân — dữ liệu hiện tại đang là mẫu, có thể thay đổi sau này." |
| 8a.2 | Quan sát **Basic Info card** | Email, Số điện thoại, Địa chỉ. Nút "Chỉnh sửa" (chưa hoạt động) | — |
| 8a.3 | Quan sát **Weekly Progress card** | "Tiến độ tuần này", "85%", thanh progress, "Xem chi tiết" | — |
| 8a.4 | Quan sát **Security section** | Đổi mật khẩu / Xác thực 2 lớp / Lịch sử đăng nhập / Đăng xuất (màu đỏ) | — |
| 8a.5 | Quan sát **Preferences section** | Dark Mode toggle, Ngôn ngữ: "Tiếng Việt" | — |
| 8a.6 | Nhấn **Back** | Quay lại Settings Screen | — |

#### 8b. Notification Settings

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 8b.1 | Nhấn **"Cấu hình thông báo"** | **Notification Settings**: Hero card + "Quản lý tuỳ chọn" | — |
| 8b.2 | Quan sát **General Settings** | "Thông báo đẩy" + toggle, "Âm báo" + toggle | "Có thể bật/tắt thông báo đẩy và âm báo." |
| 8b.3 | Quan sát **Events & Calendar** | "Nhắc nhở trước sự kiện" + toggle (15p), "Báo cáo hàng tuần" + toggle (sáng Thứ Hai) | "Tuỳ chỉnh nhắc nhở và báo cáo." |
| 8b.4 | Quan sát **Quick Settings** | "Giờ yên tĩnh" (tạm dừng thông báo) và "Ưu tiên khẩn cấp" (bỏ qua im lặng) | — |
| 8b.5 | Nhấn **Back** | Quay lại Settings Screen | — |

#### 8c. App Theme (Giao diện)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 8c.1 | Nhấn **"Giao diện ứng dụng"** | **App Theme Screen**: "Giao diện" | — |
| 8c.2 | Quan sát **Display Mode** | 3 card: "Sáng" (sun), "Tối" (moon), "Hệ thống" (auto). Card đang chọn có viền primary + icon check. | "Ứng dụng hỗ trợ 3 chế độ giao diện: Sáng, Tối và Theo hệ thống." |
| 8c.3 | Nhấn chọn **"Tối"** | Card "Tối" được highlight | — |
| 8c.4 | Quan sát **Accent Color** | 6 màu: Tím (#4D41DF), Hồng, Xanh ngọc, Cam, Xanh lam, Tím đậm. Màu đang chọn có viền trắng + check. | "Có 6 màu chủ đạo để cá nhân hoá giao diện." |
| 8c.5 | Nhấn chọn màu **Cam** | Màu Cam được highlight | — |
| 8c.6 | Nhấn **"Áp dụng thay đổi"** | Snackbar "Đã áp dụng thay đổi giao diện!" — giao diện chuyển sang Dark theme + màu Cam | "Nhấn Áp dụng — theme được cập nhật ngay lập tức qua ThemeProvider." |
| 8c.7 | Quay lại **Settings**, vào lại **Giao diện**, chọn lại **"Sáng"** + **màu Tím** + **"Áp dụng"** | Trở về giao diện mặc định | "Quay lại mặc định." |
| 8c.8 | Nhấn **Back** | Quay lại Settings Screen | — |

---

### Phần 9: Đăng xuất (Logout)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 9.1 | Nhấn nút **"Đăng xuất"** (viền đỏ, cuối Settings) | Hiện dialog: "Bạn có chắc muốn đăng xuất?" + "Huỷ" / "Đăng xuất" | — |
| 9.2 | Nhấn **"Huỷ"** | Dialog đóng, vẫn ở Settings | "Có thể huỷ." |
| 9.3 | Nhấn lại **"Đăng xuất"** + **"Đăng xuất"** (xác nhận) | Gọi `AuthProvider.logout()`, clear session trong DB, chuyển về **Login Screen** | "Sau khi xác nhận, session bị xoá và ứng dụng quay về màn hình Đăng nhập." |
| 9.4 | **Tắt ứng dụng và mở lại** | Splash → Onboarding hoặc Login (tuỳ theo session đã bị xoá) | "Kiểm tra lại luồng Splash — vì đã logout, nên ứng dụng sẽ hiển thị Onboarding/Login thay vì Dashboard." |

---

### Phần 10: Kiểm tra luồng đăng nhập (Login)

| Bước | Thao tác | Mô tả trên màn hình | Lời thoại gợi ý |
|------|----------|---------------------|-----------------|
| 10.1 | Nhập **Email** = `demo@test.com` | Login Screen | — |
| 10.2 | Nhập **Mật khẩu** = `123456` | — | — |
| 10.3 | Nhấn nút **"Đăng Nhập"** | Hiện loading, kiểm tra thông tin → nếu đúng → chuyển đến Dashboard | "Đăng nhập với tài khoản đã đăng ký trước đó. Xác thực qua AuthProvider kiểm tra thông tin từ SQLite." |
| 10.4 | Quan sát Dashboard sau login | Dữ liệu cũ (sự kiện, task) vẫn còn — vì cùng database | "Toàn bộ dữ liệu vẫn còn nguyên vì dùng chung database local." |

> **Test validation**: Nhập sai mật khẩu → thấy dòng chữ đỏ "Email hoặc mật khẩu không chính xác"

---

## Tổng kết

| Khu vực | Số màn hình | Trạng thái |
|---------|-------------|------------|
| Splash + Onboarding | 4 (1 splash + 3 slides) | ✅ Hoạt động |
| Auth (Login + Register) | 2 | ✅ Hoạt động, có validation |
| Dashboard | 1 | ✅ Hoạt động, dữ liệu từ DB |
| Calendar (Month + Agenda) | 1 | ✅ Hoạt động, có CRUD sự kiện |
| Add Event | 1 | ✅ Hoạt động, lưu DB |
| Tasks (Eisenhower) | 1 | ✅ Hoạt động, CRUD |
| Analytics | 1 | ✅ Hoạt động, số liệu từ DB |
| Settings (+ Account + Notification + Theme) | 4 | ✅ Hoạt động (Theme có áp dụng thực tế) |
| **Tổng cộng** | **15 màn hình** | |

---

## Mẹo quay video

1. **Quay mượt**: Giữ tay ổn định, click chậm rãi, chờ animation hoàn tất trước khi nói tiếp
2. **Focus từng phần**: Dùng tool vẽ (hoặc trỏ chuột) để nhấn vào khu vực đang nói
3. **Test data trước**: Nên dùng database đã có sẵn 2-3 sự kiện và 3-4 task để demo sinh động
4. **Thứ tự quay gợi ý**: Phần 1 → 2 → 4 (tạo sự kiện) → 5 → 6 → 7 → 8 → 9 → 10 → 3 (Dashboard cuối để thấy dữ liệu đầy đủ)
5. **Độ dài**: Khoảng 8-12 phút là lý tưởng cho 1 video demo đầy đủ
6. **Chuẩn bị**: Mở sẵn file này trên màn hình phụ hoặc in ra để đọc theo
