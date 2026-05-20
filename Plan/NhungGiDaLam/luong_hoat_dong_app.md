# TỔNG QUAN LUỒNG HOẠT ĐỘNG ỨNG DỤNG SCHEDULR

## 1. SƠ ĐỒ ĐIỀU HƯỚNG TỔNG THỂ

```
SplashScreen (/)
  ├── AuthProvider.checkLoginStatus()=true  ──> DashboardScreen (/dashboard)
  └── AuthProvider.checkLoginStatus()=false ──> OnboardingScreen (/onboarding)
                                                    │
                                                    └───> LoginScreen (/login)
                                                            │
                                                            ├── AuthProvider.login() OK ──> DashboardScreen
                                                            └── "Đăng ký" ──> RegisterScreen (/register)
                                                                                  │
                                                                                  └── AuthProvider.register() OK ──> DashboardScreen

DashboardScreen (Trang chủ)  ◄─── trung tâm điều hướng chính (hiển thị tên user động từ AuthProvider)
  ├── /calendar        (Lịch)
  ├── /tasks           (Công việc — Eisenhower)
  ├── /analytics       (Thống kê)
  └── /settings        (Cài đặt)
        ├── /account_info           (Hồ sơ cá nhân)
        ├── /notification_settings  (Thông báo)
        └── /app_theme              (Giao diện)
```

---

## 2. LUỒNG KHỞI ĐỘNG & XÁC THỰC

### 2.1 SplashScreen
```
Khởi động app
    │
    ├── WidgetsFlutterBinding.ensureInitialized()
    ├── AppDatabase().database (khởi tạo SQLite: 5 bảng)
    ├── Khóa orientation dọc
    ├── Chạy SchedulrApp → MultiProvider (5 providers)
    │     ├── ThemeProvider
    │     ├── AuthProvider          ← MỚI: quản lý xác thực tập trung
    │     ├── EventProvider
    │     ├── CategoryProvider
    │     └── TaskProvider
    │
    └── SplashScreen._initApp()
          │
          ├── Delay 1 giây (hiệu ứng loading)
          ├── context.read<AuthProvider>().checkLoginStatus()
          │     └── Query settings WHERE key='user_logged_in'
          │           └── TRUE → load user_email + user_name → set _user
          │
          ├── Delay 1 giây
          │
          ├── AuthProvider.isLoggedIn == true
          │     └── pushReplacementNamed('/dashboard')
          │
          └── AuthProvider.isLoggedIn == false
                └── pushReplacementNamed('/onboarding')
```

### 2.2 OnboardingScreen (3 trang hướng dẫn)
```
PageView 3 trang:
  [1] Lập lịch thông minh (AI gợi ý)
  [2] Nhắc nhở thông minh
  [3] Phân tích hiệu suất

Thao tác:
  ├── Nhấn "Bỏ qua" ──> pushReplacementNamed('/login')
  ├── Vuốt / Next ──> chuyển trang
  └── Trang cuối + "Bắt đầu" ──> pushReplacementNamed('/login')
```

### 2.3 LoginScreen (dùng AuthProvider)
```
Form đăng nhập:
  [Email]
  [Mật khẩu] (ẩn/hiện)
  [Nút Đăng nhập]        ← có CircularProgressIndicator khi đang xử lý
  [Nút Google (placeholder)]

Luồng xử lý qua AuthProvider:
  ┌──────────────────────────────────────────────────────────────┐
  │ _handleLogin():                                              │
  │   ├── Validate email + password != empty                     │
  │   ├── setState(_isLoading = true, _errorMessage = null)      │
  │   ├── context.read<AuthProvider>().login(email, password)    │
  │   │     └── AuthProvider.login():                            │
  │   │           ├── Query settings WHERE key='user_<email>'    │
  │   │           ├── NOT found → _errorMessage = 'chưa đăng ký'│
  │   │           ├── Wrong password → _errorMessage             │
  │   │           └── OK → INSERT settings + set _user → notify  │
  │   ├── setState(_isLoading=result.isLoading, _errorMessage)   │
  │   └── AuthProvider.isLoggedIn == true                        │
  │         └── pushReplacementNamed('/dashboard')              │
  └──────────────────────────────────────────────────────────────┘

Liên kết phụ:
  ├── "Quên mật khẩu?" ──> SnackBar "Tính năng đang phát triển"
  └── "Đăng ký" ──> pushNamed('/register')
```

### 2.4 RegisterScreen (dùng AuthProvider)
```
Form đăng ký:
  [Họ và tên]
  [Email]
  [Mật khẩu] (tối thiểu 6 ký tự)
  [Xác nhận mật khẩu]
  [Nút Đăng ký]           ← có loading indicator

Validation (phía UI trước khi gọi AuthProvider):
  ├── Tất cả field != empty
  ├── Email phải chứa '@'
  ├── Password >= 6 ký tự
  ├── Password == ConfirmPassword

Luồng xử lý qua AuthProvider:
  ┌──────────────────────────────────────────────────────────────────┐
  │ _handleRegister():                                               │
  │   ├── Validation (local)                                         │
  │   ├── setState(_isLoading = true)                                │
  │   ├── context.read<AuthProvider>().register(name, email, pass)   │
  │   │     └── AuthProvider.register():                             │
  │   │           ├── Kiểm tra email đã tồn tại?                     │
  │   │           ├── Transaction SQLite:                            │
  │   │           │     INSERT settings (key='user_<email>', ...)    │
  │   │           │     INSERT settings (key='user_<email>_name',...) │ ← MỚI: lưu tên theo user
  │   │           │     INSERT OR REPLACE settings (key='user_name') │
  │   │           │     INSERT OR REPLACE settings (key='user_logged_in') │
  │   │           │     INSERT OR REPLACE settings (key='user_email')│
  │   │           └── set _user → notifyListeners()                 │
  │   ├── setState(_isLoading, _errorMessage từ provider)            │
  │   └── AuthProvider.isLoggedIn == true                            │
  │         └── pushNamedAndRemoveUntil('/dashboard')               │
  └──────────────────────────────────────────────────────────────────┘
```

---

## 3. LUỒNG MÀN HÌNH CHÍNH (DashboardScreen)

DashboardScreen là trung tâm, có BottomNavigationBar 5 tab + FAB.

```
DashboardScreen State:
  ├── _selectedDate = DateTime.now()
  ├── _weekStart  = Thứ 2 của tuần hiện tại
  └── initState:
        ├── EventProvider.ensureLoaded()
        └── TaskProvider.ensureLoaded()

UI Structure:
  [Header: Avatar + "Chào buổi sáng, Alex" + Notification bell]
  [WeekStrip: Tháng 5 năm 2026 | Xem lịch]
  [   T2  T3  T4  T5  T6  T7  CN  ]
  [  25   26   27   28   29   30  31 ]  ← các ô ngày có dấu chấm sự kiện
  [ProgressCard: % hoàn thành + vòng tròn tiến độ]
  [PrioritySection: 3 sự kiện sắp tới chưa hoàn thành]
  [UpcomingEvents: 3 sự kiện sắp tới (có card ngày)]
  [FAB: +] ──> pushNamed('/add_event')
  [BottomNav: Trang chủ | Lịch | Công việc | Thống kê | Cài đặt]

Tương tác:
  ├── Chọn ngày trên WeekStrip ──> cập nhật _selectedDate
  ├── "Xem lịch" ──> pushNamed('/calendar')
  ├── "Xem tất cả" ──> pushNamed('/tasks')
  ├── FAB ──> pushNamed('/add_event')
  ├── BottomNav tab 1 ──> pushReplacementNamed('/calendar')
  ├── BottomNav tab 2 ──> pushReplacementNamed('/tasks')
  ├── BottomNav tab 3 ──> pushReplacementNamed('/analytics')
  └── BottomNav tab 4 ──> pushReplacementNamed('/settings')
```

---

## 4. LUỒNG QUẢN LÝ SỰ KIỆN (Calendar + AddEvent)

### 4.1 CalendarScreen
```
State:
  ├── _viewIndex: 0 (Tháng) | 1 (Tuần) | 2 (Ngày) — UI toggle, chưa xử lý khác biệt
  ├── _currentMonth, _selectedDate
  └── initState: EventProvider.ensureLoaded() + loadEventsForDate()

UI Structure:
  [Header: Schedulr + Notification]
  [Toggle: Tháng | Tuần | Ngày] ← segmented control
  [Tháng 5 năm 2026  <  >]
  [ T2  T3  T4  T5  T6  T7  CN ]
  [                    1   2   3 ]  ← ngày tháng trước mờ
  [  4   5   6   7   8   9  10  ]  ← có dấu chấm màu sự kiện
  [ ...                            ]
  [Agenda: "Thứ Hai, ngày 16 tháng 5" — 3 Sự kiện đã lên lịch]
  [  | Sự kiện 1  10:00-11:00  🗑️ ]
  [  | Sự kiện 2  14:00-15:00  🗑️ ]
  [FAB nhỏ: +] ──> pushNamed('/add_event')
  [BottomNav: Lịch]

Tương tác:
  ├── Nhấn ngày ──> cập nhật _selectedDate, loadEventsForDate
  ├── < > tháng ──> chuyển tháng
  ├── Nhấn sự kiện 🗑️ ──> Dialog xác nhận ──> eventProvider.deleteEvent(id)
  ├── FAB + ──> pushNamed('/add_event')
  └── BottomNav ──> chuyển tab
```

### 4.2 AddEventScreen
```
Form thêm sự kiện:
  [Tên sự kiện] ← font 32px, tự động focus
  [Bắt đầu: 16 Tháng 5, 2026  | 09:00]  ← nhấn để chọn ngày/giờ
  [ → ]
  [Kết thúc: 16 Tháng 5, 2026  | 10:00]
  [☑ Cả ngày] ← Switch
  [DANH MỤC]
  [ (•) Công việc  ( ) Học tập  ( ) Cá nhân  ( ) Sức khỏe ] ← ChoiceChips
  [NHẮC NHỞ]
  [ 5 phút | 15 phút | 30 phút ] ← radio-style
  [CÔNG VIỆC CON]
  [☐ Việc nhỏ 1  ✕]
  [☑ Việc nhỏ 2  ✕]
  [ + Thêm công việc con... [➕] ]
  [=== Nút LƯU ===]

Luồng lưu:
  ┌─────────────────────────────────────────────────────────┐
  │ _saveEvent():                                           │
  │   ├── Validate title != empty                           │
  │   ├── Build startDateTime, endDateTime từ date + time   │
  │   ├── categoryProvider.getCategoryById() → colorHex     │
  │   ├── Tạo Event(...)                                    │
  │   ├── eventProvider.addEvent(event)                     │
  │   │     └── eventRepository.insertEvent(event)          │
  │   │           ├── INSERT INTO events (...)               │
  │   │           └── INSERT INTO subtasks (...) (nếu có)   │
  │   └── Navigator.pop()                                   │
  └─────────────────────────────────────────────────────────┘
```

---

## 5. LUỒNG QUẢN LÝ CÔNG VIỆC (TasksScreen — Eisenhower Matrix)

```
TasksScreen (StatefulWidget, không có state riêng — đọc từ TaskProvider)

initState: context.read<TaskProvider>().loadTasks()

UI Structure:
  [Header: Schedulr + Notification]
  [Eisenhower Matrix]
  [                         ]
  [ ⚡ LÀM NGAY     3 Công việc  [+]]
  [  ☐ Việc A  ✕                ]
  [  ☑ Việc B  ✕                ]
  [                         ]
  [ 📅 LÊN LỊCH     1 Công việc  [+]]
  [  ☐ Việc C  ✕                ]
  [                         ]
  [ 👥 ỦY THÁC     0 Công việc  [+]]
  [                         ]
  [ 🗑️ LOẠI BỎ     2 Công việc  [+]]
  [  ☑ Việc D (gạch ngang)  ✕   ]
  [                         ]
  [BottomNav: Công việc]

4 Quadrants:
  ┌─────────────────────┬─────────────────────┐
  │  0. LÀM NGAY        │  1. LÊN LỊCH        │
  │  (Khẩn + Quan trọng)│  (Không khẩn + Qt)  │
  │  Màu: primary       │  Màu: secondary     │
  ├─────────────────────┼─────────────────────┤
  │  2. ỦY THÁC         │  3. LOẠI BỎ         │
  │  (Khẩn + Ko Qt)     │  (Ko khẩn + Ko Qt)  │
  │  Màu: tertiary      │  Màu: gạch ngang    │
  └─────────────────────┴─────────────────────┘

Tương tác:
  ├── Nhấn [+] trên mỗi quadrant ──> Dialog thêm task
  │     └── Nhập tên ──> taskProvider.addTask(TaskItem(quadrant: N))
  │
  ├── Nhấn checkbox (☐/☑) ──> taskProvider.toggleTaskComplete(id)
  │
  ├── Nhấn ✕ ──> taskProvider.deleteTask(id)
  │
  └── BottomNav ──> chuyển tab
```

---

## 6. LUỒNG THỐNG KÊ (AnalyticsScreen)

```
AnalyticsScreen State:
  initState: EventProvider.ensureLoaded() + TaskProvider.ensureLoaded()

UI Structure:
  [Header: Schedulr + Notification]
  [                              ]
  [  Tiến độ tuyệt vời!  |  85/100]
  [  Hoàn thành 5/6     |  ███░░ ]
  [                              ]
  [  HOÀN THÀNH CÔNG VIỆC  Tuần này]
  [  █  ██  █  ███  ██  █  ██  ]
  [  T   H   B   N    S   B   C  ]
  [                              ]
  [  PHÂN BỔ THỜI GIAN  |  THỐNG KÊ TẬP TRUNG]
  [   ╭───╮             |  Tổng sự kiện: 12   ]
  [   │◯◯◯│             |  Đã hoàn thành: 8   ]
  [   ╰───╯             |  Còn lại: 4         ]
  [  • Công việc 45%    |                      ]
  [  • Sức khỏe 25%     |                      ]
  [  • Cá nhân 20%      |                      ]
  [                              ]
  [  HOẠT ĐỘNG 30 NGÀY          ]
  [  Ít ■■■■■■■■ Nhiều          ]
  [                              ]
  [  GỢI Ý THÔNG MINH            ]
  [  💡 Đỉnh cao buổi sáng...   ]
  [  ⚠ Tiến độ tổng thể 5/6...  ]
  [                              ]
  [BottomNav: Thống kê]

Nguồn dữ liệu:
  ├── TaskProvider.tasks (tổng số + đã hoàn thành)
  ├── EventProvider.events (tổng sự kiện)
  ├── Bar chart: taskProvider.getCompletedByDay(days: 7)
  ├── Donut chart: dữ liệu tĩnh (45/25/20)
  └── Heatmap: placeholder UI

Tương tác:
  └── BottomNav ──> chuyển tab
```

---

## 7. LUỒNG CÀI ĐẶT (Settings)

### 7.1 SettingsScreen
```
UI Structure:
  [Header: Avatar + Schedulr + Notification]
  [                                      ]
  [  👤 {AuthProvider.user.name}         ] ← động
  [  {AuthProvider.user.email}           ] ← động
  [  [Thành viên Pro]                   ]
  [                                      ]
  [  TÀI KHOẢN                          ]
  [  👤 Thông tin cá nhân        >      ] ──> /account_info
  [  🛡️ Bảo mật                  >      ] (placeholder)
  [                                      ]
  [  ỨNG DỤNG                           ]
  [  🔔 Cấu hình thông báo      >      ] ──> /notification_settings
  [  🎨 Giao diện                >      ] ──> /app_theme
  [                                      ]
  [  [🚪 Đăng xuất] (màu đỏ)           ]
  [                                      ]
  [  Schedulr Phiên bản 2.4.0           ]
  [  © 2024 Schedulr Inc.               ]
  [BottomNav: Cài đặt]

Đăng xuất:
  ┌──────────────────────────────────────────────────┐
  │ _handleLogout():                                  │
  │   ├── Dialog xác nhận "Bạn có chắc...?"          │
  │   ├── YES ──> context.read<AuthProvider>().logout()│
  │   │     └── INSERT OR REPLACE user_logged_in=false│
  │   │     └── set _user = null → notifyListeners() │
  │   └── pushNamedAndRemoveUntil('/login')          │
  └──────────────────────────────────────────────────┘
```

### 7.2 AccountInfoScreen
```
UI:
  [< Hồ sơ cá nhân]
  [   ⭕👤⭕ (avatar + camera)  ]
  [   Nguyễn Minh Tuấn         ]
  [   Sinh viên năm 3 • ĐHBK  ]
  [                            ]
  [  Thông tin cơ bản  [Chỉnh sửa]]
  [  Email: minhtuan@example   ]
  [  SĐT: +84 987 654 321      ]
  [  Địa chỉ: Quận 1, TPHCM   ]
  [                            ]
  [  Tiến độ tuần này          ]
  [  ███████░░░ 85%            ]
  [  [Xem chi tiết]            ]
  [                            ]
  [  Bảo mật & Tài khoản       ]
  [  🔒 Đổi mật khẩu           ]
  [  ✅ Xác thực 2 lớp         ]
  [  📋 Lịch sử đăng nhập      ]
  [  🚪 Đăng xuất (đỏ)        ]
  [                            ]
  [  Tùy chỉnh ứng dụng         ]
  [  🌙 Chế độ tối    [OFF]    ]
  [  🌐 Ngôn ngữ     Tiếng Việt]
```

### 7.3 NotificationSettingsScreen
```
State: _pushEnabled, _soundEnabled, _reminderEnabled, _weeklyReportEnabled

UI:
  [< Thông báo]
  [🔔 Quản lý tùy chọn]
  [  Tùy chỉnh cách bạn nhận thông báo...]
  [                            ]
  [CÀI ĐẶT CHUNG               ]
  [📶 Thông báo đẩy        [ON ]]
  [🔊 Âm báo               [OFF]]
  [                            ]
  [SỰ KIỆN & LỊCH              ]
  [📝 Nhắc nhở sự kiện     [ON ]]
  [📊 Báo cáo hàng tuần    [OFF]]
  [                            ]
  [⏰ Giờ yên tĩnh | 🚨 Ưu tiên khẩn cấp]
```

### 7.4 AppThemeScreen
```
State: _selectedTheme (0=Sáng, 1=Tối, 2=Hệ thống), _selectedColor (0-5)

UI:
  [< Giao diện]
  [Chế độ hiển thị]
  [ ☀️ Sáng | 🌙 Tối | 💻 Hệ thống ]
  [                                ]
  [Màu chủ đạo]
  [ ●●●●●● (6 màu: Tím, Hồng, Xanh lục, Cam, Xám, Tím đậm) ]
  [                                ]
  [ [ÁP DỤNG THAY ĐỔI] ]

Luồng:
  initState:
    ├── Đọc ThemeProvider.themeMode → _selectedTheme
    └── Đọc ThemeProvider.colorSeed → _selectedColor

  _applyChanges():
    ├── themeProvider.setThemeMode(mode)
    ├── themeProvider.setColorSeed(color)
    └── SnackBar "Đã áp dụng thay đổi giao diện!"
```

---

## 8. LUỒNG DỮ LIỆU (DATA FLOW)

### 8.1 Kiến trúc tổng thể
```
┌─────────────────────────────────────────────────────────────┐
│                      UI LAYER                                │
│  Screens (StatefulWidget/StatelessWidget)                    │
│    ├── DashboardScreen, CalendarScreen, TasksScreen...       │
│    ├── LoginScreen → AuthProvider (thay vì query DB trực tiếp)│
│    └── Sử dụng Consumer<Provider> / context.watch            │
├─────────────────────────────────────────────────────────────┤
│                   STATE MANAGEMENT                            │
│  Provider (ChangeNotifier) — 5 providers                     │
│    ├── AuthProvider      (MỚI) xác thực + User entity        │
│    ├── EventProvider     (quản lý danh sách sự kiện)         │
│    ├── TaskProvider      (quản lý danh sách task)            │
│    ├── CategoryProvider  (quản lý danh mục)                  │
│    └── ThemeProvider     (quản lý giao diện)                 │
├─────────────────────────────────────────────────────────────┤
│                  REPOSITORY LAYER                              │
│    ├── EventRepository    (CRUD events + subtasks)            │
│    ├── TaskRepository     (CRUD tasks)                        │
│    └── CategoryRepository (CRUD categories)                   │
├─────────────────────────────────────────────────────────────┤
│                   DATABASE LAYER                               │
│  SQLite (sqflite) — 5 tables + settings (auth)               │
│    ├── events        (sự kiện lịch)                           │
│    ├── categories    (danh mục)                               │
│    ├── subtasks      (công việc con của sự kiện)              │
│    ├── tasks         (công việc Eisenhower)                   │
│    └── settings      (cấu hình người dùng + auth state)       │
└─────────────────────────────────────────────────────────────┘

Ghi chú: Khi chuyển sang REST API, AuthProvider sẽ gọi AuthRepository
thay vì settings table, và luồng dữ liệu sẽ là:
  UI → AuthProvider → AuthRepository → ApiService (HTTP) → Backend API
```

### 8.2 Chi tiết các bảng CSDL

**Bảng events**
| Column | Type | Ghi chú |
|--------|------|---------|
| id | INTEGER | PK AUTOINCREMENT |
| title | TEXT | NOT NULL |
| description | TEXT | nullable |
| startTime | TEXT | ISO8601 |
| endTime | TEXT | ISO8601 |
| location | TEXT | nullable |
| categoryId | TEXT | FK đến categories |
| colorHex | INTEGER | DEFAULT 0xFF4D41DF |
| isAllDay | INTEGER | 0/1 |
| isRecurring | INTEGER | 0/1 |
| recurrenceRule | TEXT | nullable |
| reminderMinutes | TEXT | JSON array |
| isCompleted | INTEGER | 0/1 |
| createdAt | TEXT | NOT NULL |
| updatedAt | TEXT | NOT NULL |

**Bảng categories**
| Column | Type | Ghi chú |
|--------|------|---------|
| id | INTEGER | PK AUTOINCREMENT |
| name | TEXT | NOT NULL |
| colorHex | INTEGER | NOT NULL |
| iconCode | TEXT | mã icon Flutter |

Seed data mặc định: Công việc (tím), Học tập (cam), Cá nhân (đỏ), Sức khỏe (xanh lục)

**Bảng subtasks**
| Column | Type | Ghi chú |
|--------|------|---------|
| id | INTEGER | PK AUTOINCREMENT |
| eventId | INTEGER | FK → events(id) ON DELETE CASCADE |
| title | TEXT | NOT NULL |
| isCompleted | INTEGER | 0/1 |
| sortOrder | INTEGER | thứ tự sắp xếp |

**Bảng tasks**
| Column | Type | Ghi chú |
|--------|------|---------|
| id | INTEGER | PK AUTOINCREMENT |
| title | TEXT | NOT NULL |
| description | TEXT | nullable |
| quadrant | INTEGER | 0-3 (Eisenhower) |
| isCompleted | INTEGER | 0/1 |
| dueDate | TEXT | nullable |
| createdAt | TEXT | NOT NULL |

**Bảng settings**
| Column | Type | Ghi chú |
|--------|------|---------|
| key | TEXT | PK |
| value | TEXT | NOT NULL |

---

## 9. LUỒNG SỰ KIỆN NGƯỜI DÙNG CHI TIẾT

### 9.1 Luồng: Người dùng mới tạo tài khoản
```
1. Mở app ──> Splash (2s) ──> Onboarding (3 trang)
2. Bỏ qua / Hết onboarding ──> Login
3. Nhấn "Đăng ký" ──> Register
4. Điền: Họ tên, Email, Mật khẩu, Xác nhận MK
5. Nhấn Đăng ký (loading indicator hiện)
6. Validation UI OK ──> AuthProvider.register(name, email, pass)
     ├── AuthProvider kiểm tra email đã tồn tại (settings table)
     ├── Transaction: INSERT user_<email>, user_<email>_name, user_name,
     │               user_logged_in=true, user_email
     ├── setState: _isLoading=false
     └── isLoggedIn=true ──> pushNamedAndRemoveUntil('/dashboard')
   Validation lỗi ──> Hiển thị lỗi tương ứng (UI + AuthProvider.errorMessage)
```

### 9.2 Luồng: Người dùng cũ đăng nhập
```
1. Mở app ──> Splash ──> AuthProvider.checkLoginStatus()
     ├── user_logged_in=true ──> set _user (email + name) ──> Dashboard
     └── user_logged_in=false ──> Onboarding ──> Login

2. Login: Nhập Email + Mật khẩu
3. Nhấn Đăng nhập (loading indicator + disabled button)
4. AuthProvider.login(email, password)
     ├── Query settings WHERE key='user_<email>'
     ├── NOT found ──> _errorMessage = 'Email chưa được đăng ký'
     ├── Sai mật khẩu ──> _errorMessage = 'Mật khẩu không đúng'
     └── OK ──> INSERT user_logged_in=true, user_email, user_name
             ──> set _user(User) ──> notifyListeners()
             ──> pushReplacementNamed('/dashboard')
```

### 9.3 Luồng: Thêm sự kiện mới
```
1. Dashboard (FAB +) / Calendar (FAB +) ──> AddEventScreen
2. Nhập tên sự kiện (tự động focus)
3. Chọn ngày/giờ bắt đầu:
   └── Nhấn card "Bắt đầu" ──> DatePicker ──> TimePicker
4. Chọn ngày/giờ kết thúc (tương tự)
5. Bật "Cả ngày" nếu cần
6. Chọn danh mục (ChoiceChips)
7. Chọn nhắc nhở: 5 / 15 / 30 phút
8. Thêm công việc con (nếu cần):
   └── Nhập text + nhấn Enter/➕ ──> subtask xuất hiện
9. Nhấn LƯU
10. SaveEvent:
    ├── Build Event entity
    ├── eventProvider.addEvent(event)
    │     └── eventRepository.insertEvent(event)
    │           ├── INSERT events
    │           └── INSERT subtasks (nếu có)
    └── Navigator.pop() ──> quay lại màn hình trước
```

### 9.4 Luồng: Xem và xóa sự kiện
```
1. Calendar ──> Chọn ngày ──> Agenda hiện danh sách
2. Xem chi tiết: từng sự kiện có title + giờ + màu danh mục
3. Xóa:
   └── Nhấn 🗑️ ──> Dialog "Xóa sự kiện?" ──> Có
         └── eventProvider.deleteEvent(id)
               └── DELETE subtasks WHERE eventId=id
               └── DELETE events WHERE id=id
```

### 9.5 Luồng: Quản lý công việc Eisenhower
```
1. Tasks ──> Xem 4 ô quadrants
2. Thêm task mới:
   └── Nhấn [+] trên quadrant muốn thêm
         └── Dialog nhập tên ──> taskProvider.addTask()
               └── taskRepository.insertTask()
3. Hoàn thành task:
   └── Nhấn checkbox ──> taskProvider.toggleTaskComplete(id)
4. Xóa task:
   └── Nhấn ✕ ──> taskProvider.deleteTask(id)
```

### 9.6 Luồng: Chỉnh giao diện
```
1. Settings ──> Giao diện ──> AppThemeScreen
2. Chọn chế độ: Sáng / Tối / Hệ thống (card UI)
3. Chọn màu chủ đạo: 1 trong 6 màu (vòng tròn)
4. Nhấn "Áp dụng thay đổi"
   ├── ThemeProvider.setThemeMode(mode)
   ├── ThemeProvider.setColorSeed(colorHex)
   ├── Cập nhật toàn bộ giao diện ngay lập tức
   └── SnackBar xác nhận
```

### 9.7 Luồng: Đăng xuất
```
1. Settings ──> Nút "Đăng xuất" (đỏ)
2. Dialog "Bạn có chắc muốn đăng xuất?"
   ├── Hủy ──> đóng dialog
   └── Đăng xuất:
         ├── context.read<AuthProvider>().logout()
         │     └── INSERT OR REPLACE settings: user_logged_in=false
         │     └── set _user = null → notifyListeners()
         ├── mounted check
         └── pushNamedAndRemoveUntil('/login')
```

---

## 10. LUỒNG PROVIDER CHI TIẾT

### 10.1 AuthProvider (MỚI)
```
State:
  - User? _user              (email + name)
  - bool _isLoading
  - bool _isInitialized
  - String? _errorMessage

Computed getters:
  user          ──> _user
  isLoggedIn    ──> _user != null
  isLoading     ──> _isLoading
  isInitialized ──> _isInitialized
  errorMessage  ──> _errorMessage

Methods:
  checkLoginStatus()
    ├── Query settings WHERE key='user_logged_in'
    ├── TRUE → load user_email + user_name → set _user
    └── _isInitialized = true → notifyListeners()

  login(email, password)
    ├── _isLoading = true
    ├── Query settings WHERE key='user_<email>'
    ├── NOT found → _errorMessage → return
    ├── Wrong password → _errorMessage → return
    ├── OK → INSERT/REPLACE user_logged_in, user_email, user_name
    ├── set _user = User(email, name)
    └── _isLoading = false → notifyListeners()

  register(name, email, password)
    ├── _isLoading = true
    ├── Kiểm tra email tồn tại
    ├── Transaction: user_<email>, user_<email>_name, user_name,
    │               user_logged_in, user_email
    ├── set _user = User(email, name)
    └── _isLoading = false → notifyListeners()

  logout()
    ├── INSERT/REPLACE settings: user_logged_in=false
    ├── _user = null
    └── notifyListeners()

  clearError()
    └── _errorMessage = null → notifyListeners()

Database keys:
  'user_logged_in'    = 'true' | 'false'
  'user_email'        = email
  'user_name'         = tên hiển thị
  'user_<email>'      = password (plaintext — tạm)
  'user_<email>_name' = tên đầy đủ (MỚI — lưu tên theo từng user)
```

### 10.2 EventProvider
```
State:
  - List<Event> _events
  - List<Event> _currentDayEvents
  - bool _initialized

Methods:
  ensureLoaded()      ──> nếu !_initialized thì loadEvents()
  loadEvents()        ──> eventRepository.getAllEvents() → _events
  loadEventsForDate(d)──> eventRepository.getEventsForDate(d) → _currentDayEvents
  addEvent(event)     ──> repository.insertEvent → loadEvents()
  updateEvent(event)  ──> repository.updateEvent → loadEvents()
  deleteEvent(id)     ──> repository.deleteEvent → loadEvents()
  toggleEventComplete ──> repository.toggleComplete → loadEvents()
  getEventsOnDate(d)  ──> filter _events theo ngày (client-side)
```

### 10.3 TaskProvider
```
State:
  - List<TaskItem> _tasks
  - bool _initialized

Computed getters:
  urgentImportant           ──> quadrant == 0
  notUrgentImportant        ──> quadrant == 1
  urgentNotImportant        ──> quadrant == 2
  notUrgentNotImportant     ──> quadrant == 3

Methods:
  loadTasks()               ──> repository.getAllTasks() → _tasks
  addTask(task)             ──> repository.insertTask → loadTasks()
  updateTask(task)          ──> repository.updateTask → loadTasks()
  deleteTask(id)            ──> repository.deleteTask → loadTasks()
  toggleTaskComplete(id)    ──> repository.toggleComplete → loadTasks()
  getCompletedByDay(days)   ──> repository.getCompletedTasksByDay()
```

### 10.4 CategoryProvider
```
State:
  - List<Category> _categories

Methods:
  loadCategories()          ──> repository.getAllCategories()
  getCategoryById(id)       ──> tìm trong _categories
  getColorForCategory(id)   ──> parse → lookup → Color
  getNameForCategory(id)    ──> parse → lookup → name
```

### 10.5 ThemeProvider
```
State:
  - ThemeMode _themeMode (default: light)
  - int _colorSeed (default: 0xFF4D41DF)
  - ThemeData? _cachedLight
  - ThemeData? _cachedDark

Methods:
  setThemeMode(mode)        ──> _themeMode = mode, invalidate cache
  setColorSeed(hex)         ──> _colorSeed = hex, invalidate cache
  lightTheme getter         ──> build + cache nếu null
  darkTheme getter          ──> build + cache nếu null

Theme building:
  ColorScheme.fromSeed(seedColor: Color(_colorSeed), brightness: ...)
  + google_fonts (Plus Jakarta Sans)
  + Material 3
```

---

## 11. RESPONSIVE BREAKPOINTS

Ứng dụng hỗ trợ 3 nhóm màn hình:

| Loại | Width | Padding | Layout behavior |
|------|-------|---------|-----------------|
| Nhỏ (Phone nhỏ) | < 400dp | 16dp | Column thay Row, full-width buttons, font scale 0.8 |
| Vừa (Phone lớn) | 400-600dp | 24dp | Row song song, card 2 cột |
| Lớn (Tablet) | ≥ 600dp | 32dp | Row, card max 480dp, font scale 1.3 |

---

## 12. DANH SÁCH MÀN HÌNH & TUYẾN ĐƯỜNG

| # | Màn hình | Route | Widget | BottomNav | Provider chính |
|---|----------|-------|--------|-----------|----------------|
| 1 | Splash | `/` | SplashScreen | — | AuthProvider |
| 2 | Onboarding | `/onboarding` | OnboardingScreen | — | — |
| 3 | Đăng nhập | `/login` | LoginScreen | — | AuthProvider |
| 4 | Đăng ký | `/register` | RegisterScreen | — | AuthProvider |
| 5 | Trang chủ | `/dashboard` | DashboardScreen | Index 0 | AuthProvider, EventProvider, TaskProvider |
| 6 | Lịch | `/calendar` | CalendarScreen | Index 1 | EventProvider |
| 7 | Thêm sự kiện | `/add_event` | AddEventScreen | — | EventProvider, CategoryProvider |
| 8 | Công việc | `/tasks` | TasksScreen | Index 2 | TaskProvider |
| 9 | Thống kê | `/analytics` | AnalyticsScreen | Index 3 | EventProvider, TaskProvider |
| 10 | Cài đặt | `/settings` | SettingsScreen | Index 4 | AuthProvider |
| 11 | Hồ sơ cá nhân | `/account_info` | AccountInfoScreen | — | — |
| 12 | Thông báo | `/notification_settings` | NotificationSettingsScreen | — | — |
| 13 | Giao diện | `/app_theme` | AppThemeScreen | — | ThemeProvider |

---

*Tài liệu được tạo ngày 16/05/2026 — dựa trên mã nguồn Schedulr Flutter App.*

---

## 13. KẾ HOẠCH TÍCH HỢP API & AUTHENTICATION (Phase 3)

### 13.1 Kiến trúc dự kiến khi chuyển sang REST API

```
┌──────────────────────────────────────────────────────────────┐
│                        UI LAYER                               │
│  LoginScreen / RegisterScreen / SplashScreen / SettingsScreen │
└──────────────────────────┬───────────────────────────────────┘
                           │ context.read<AuthProvider>()
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT                            │
│  AuthProvider (ChangeNotifier) — GIỮ NGUYÊN interface         │
│  (isLoggedIn, user, login(), register(), logout(), ...)       │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                    REPOSITORY LAYER (MỚI)                      │
│  AuthRepository                                              │
│    ├── login(email, pass) → POST /api/auth/login → JWT       │
│    ├── register(name, email, pass) → POST /api/auth/register │
│    ├── logout() → POST /api/auth/logout                      │
│    └── getProfile() → GET /api/auth/profile                  │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                    SERVICE LAYER (MỚI)                         │
│  ApiService                                                  │
│    ├── HTTP client (base URL, headers, timeout)              │
│    ├── Token interceptor (gắn JWT vào Authorization header)  │
│    ├── Refresh token logic (khi 401)                         │
│    └── Error handling tập trung                              │
└──────────────────────────┬───────────────────────────────────┘
                           │ http package
                           ▼
                    ┌──────────────┐
                    │  BACKEND API │
                    │  (REST)      │
                    └──────────────┘
```

### 13.2 Các bước thực hiện

#### Bước 1: Thêm packages
```yaml
dependencies:
  http: ^1.2.0              # REST API calls
  shared_preferences: ^2.2.0 # Lưu JWT token
```

#### Bước 2: Tạo ApiService
- File: `lib/data/services/api_service.dart`
- Base URL configurable
- POST/GET/PUT/DELETE methods
- Auto-attach Bearer token
- Handle 401 → refresh token → retry

#### Bước 3: Tạo AuthRepository
- File: `lib/data/repositories/auth_repository.dart`
- Implement 4 methods: login, register, logout, getProfile
- Gọi ApiService với endpoint tương ứng

#### Bước 4: Cập nhật AuthProvider
- Giữ nguyên interface (không ảnh hưởng UI)
- Thay local DB logic bằng AuthRepository calls
- Lưu JWT token vào SharedPreferences
- Kiểm tra token expiry khi checkLoginStatus()

#### Bước 5: Cập nhật DB
- Thêm bảng `users` riêng (id, email, name, password_hash, created_at)
- Migration database từ v1 lên v2
- Hoặc giữ settings table cho local cache + sync với API

### 13.3 API Endpoints dự kiến

| Method | Endpoint | Mô tả | Request Body | Response |
|--------|----------|-------|-------------|----------|
| POST | `/api/auth/register` | Đăng ký | `{name, email, password}` | `{token, user}` |
| POST | `/api/auth/login` | Đăng nhập | `{email, password}` | `{token, user}` |
| POST | `/api/auth/logout` | Đăng xuất | — | `{message}` |
| POST | `/api/auth/refresh` | Refresh token | `{refreshToken}` | `{token}` |
| GET | `/api/auth/profile` | Lấy profile | — | `{user}` |

### 13.4 Lưu ý bảo mật
- JWT token lưu trong SharedPreferences (hoặc flutter_secure_storage cho production)
- Auto logout khi token hết hạn
- Interceptor tự động refresh token
- Error handling: 401 → redirect về Login
- Không lưu password plaintext (dùng password_hash phía backend)

---

*Tài liệu được cập nhật ngày 16/05/2026 — dựa trên mã nguồn Schedulr Flutter App v2.0 (đã hoàn thiện luồng khởi động & xác thực).*
