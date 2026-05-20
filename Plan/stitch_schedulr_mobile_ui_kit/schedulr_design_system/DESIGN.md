---
name: Schedulr Design System
colors:
  surface: '#fcf8ff'
  surface-dim: '#dcd8e5'
  surface-bright: '#fcf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f2ff'
  surface-container: '#f0ecf9'
  surface-container-high: '#eae6f3'
  surface-container-highest: '#e4e1ee'
  on-surface: '#1b1b24'
  on-surface-variant: '#464555'
  inverse-surface: '#302f39'
  inverse-on-surface: '#f3effc'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4f44e2'
  primary: '#4d41df'
  on-primary: '#ffffff'
  primary-container: '#675df9'
  on-primary-container: '#fffbff'
  inverse-primary: '#c4c0ff'
  secondary: '#b0284b'
  on-secondary: '#ffffff'
  secondary-container: '#fd6483'
  on-secondary-container: '#670023'
  tertiary: '#914800'
  on-tertiary: '#ffffff'
  tertiary-container: '#b65c00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e3dfff'
  primary-fixed-dim: '#c4c0ff'
  on-primary-fixed: '#100069'
  on-primary-fixed-variant: '#3622ca'
  secondary-fixed: '#ffd9dd'
  secondary-fixed-dim: '#ffb2bc'
  on-secondary-fixed: '#400012'
  on-secondary-fixed-variant: '#8f0935'
  tertiary-fixed: '#ffdcc6'
  tertiary-fixed-dim: '#ffb785'
  on-tertiary-fixed: '#301400'
  on-tertiary-fixed-variant: '#713700'
  background: '#fcf8ff'
  on-background: '#1b1b24'
  surface-variant: '#e4e1ee'
  background-light: '#F8F9FA'
  surface-light: '#FFFFFF'
  text-primary-light: '#1A1A2E'
  text-secondary-light: '#6C757D'
  background-dark: '#121212'
  surface-dark: '#1E1E2E'
  text-primary-dark: '#E8E8F0'
  primary-dark-accent: '#7B74FF'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  gutter: 16px
  margin-mobile: 16px
---

# 📅 Personal Scheduler App — Tài liệu Đặc tả Hệ thống

> **Nền tảng:** Flutter (Dart) · **Phiên bản tài liệu:** 1.0 · **Loại dự án:** Đồ án tốt nghiệp

---

## Mục lục

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Kiến trúc hệ thống](#2-kiến-trúc-hệ-thống)
3. [Luồng hoạt động](#3-luồng-hoạt-động)
4. [Các chức năng cốt lõi](#4-các-chức-năng-cốt-lõi)
5. [Thiết kế cơ sở dữ liệu](#5-thiết-kế-cơ-sở-dữ-liệu)
6. [Màn hình & UI/UX](#6-màn-hình--uiux)
7. [Stack công nghệ](#7-stack-công-nghệ)
8. [Cấu trúc thư mục dự án](#8-cấu-trúc-thư-mục-dự-án)
9. [Các điểm mở rộng](#9-các-điểm-mở-rộng)
10. [Prompt thiết kế UI/UX](#10-prompt-thiết-kế-uiux)

---

## 1. Tổng quan dự án

### Mô tả
Ứng dụng quản lý lịch trình cá nhân (Personal Scheduler) trên nền tảng Flutter, hỗ trợ người dùng lên kế hoạch, theo dõi công việc và nhận nhắc nhở thông minh — hoạt động cả online lẫn offline.

### Mục tiêu chính
- Giúp người dùng quản lý thời gian hiệu quả thông qua giao diện trực quan
- Đồng bộ lịch trình đa thiết bị qua Cloud
- Hỗ trợ offline-first, không gián đoạn khi mất mạng
- Tích hợp AI để nhận diện lịch qua ngôn ngữ tự nhiên (điểm cộng)

### Đối tượng người dùng
| Nhóm | Nhu cầu chính |
|---|---|
| Sinh viên | Quản lý lịch học, deadline, thi cử |
| Nhân viên văn phòng | Lịch họp, công việc nhóm, deadline dự án |
| Freelancer | Quản lý nhiều dự án, theo dõi giờ làm việc |
| Người dùng cá nhân | Thói quen, sức khỏe, việc nhà |

---

## 2. Kiến trúc hệ thống

### Sơ đồ tổng thể

```
┌─────────────────────────────────────────────────────┐
│                  Flutter App (Client)                │
│  ┌──────────┐  ┌──────────┐  ┌────────────────────┐ │
│  │   UI     │  │  BLoC /  │  │  Repository Layer  │ │
│  │ Widgets  │◄─►Riverpod  │◄─►  (Data Sources)    │ │
│  └──────────┘  └──────────┘  └────────────────────┘ │
│                               │           │          │
│                        Local DB      Remote API      │
│                        (Isar)        (Firebase)      │
└─────────────────────────────────────────────────────┘
```

### Mô hình Clean Architecture

```
lib/
├── presentation/     ← UI Layer (Screens, Widgets, BLoC)
├── domain/           ← Business Logic (Use Cases, Entities)
└── data/             ← Data Layer (Repositories, Data Sources)
```

### Nguyên tắc thiết kế
- **Offline-First**: Mọi thao tác ghi/đọc ưu tiên local database trước
- **Reactive UI**: State Management cập nhật giao diện tức thì không cần reload
- **Separation of Concerns**: Tách biệt rõ UI, logic nghiệp vụ và dữ liệu
- **Repository Pattern**: Ẩn chi tiết nguồn dữ liệu khỏi tầng domain

---

## 3. Luồng hoạt động

### 3.1 Luồng người dùng (User Flow)

```
[Mở ứng dụng]
      │
      ▼
[Kiểm tra phiên đăng nhập]
      │
      ├── Chưa đăng nhập ──► [Màn hình Login]
      │                           │
      │                    Google / Email
      │                           │
      └── Đã đăng nhập ◄──────────┘
                │
                ▼
         [Dashboard]
         ┌──────────────────────────────┐
         │ • Lịch trình hôm nay         │
         │ • Công việc ưu tiên          │
         │ • Thanh tiến độ hoàn thành   │
         └──────────────────────────────┘
                │
        ┌───────┼───────┐
        ▼       ▼       ▼
   [Calendar] [Tasks] [Analytics]
```

### 3.2 Luồng thêm sự kiện mới

```
[Nhấn nút "+" hoặc nhập lệnh AI]
          │
          ▼
[Form nhập thông tin sự kiện]
  • Tiêu đề, mô tả
  • Thời gian bắt đầu / kết thúc
  • Danh mục & màu sắc
  • Lặp lại? → Cấu hình lịch lặp
  • Nhắc nhở? → Chọn thời gian nhắc
          │
          ▼
[Kiểm tra xung đột thời gian]
          │
     ┌────┴────┐
     ▼         ▼
[Có xung đột]  [Không xung đột]
[Cảnh báo &    [Lưu vào Isar DB]
 gợi ý slot]         │
                      ▼
               [Sync lên Firebase]
                      │
                      ▼
               [Đặt Local Notification]
                      │
                      ▼
               [Cập nhật UI ngay lập tức]
```

### 3.3 Luồng dữ liệu kỹ thuật

```
Action (User)
    │
    ▼
BLoC / Riverpod (Event)
    │
    ▼
Use Case (Domain Layer)
    │
    ▼
Repository (Interface)
    │
    ├──► Local Data Source (Isar) ──► Trả về ngay cho UI
    │
    └──► Remote Data Source (Firebase) ──► Sync nền
              │
              ▼
         Firestore / Realtime DB
```

### 3.4 Luồng Offline → Online

```
[Mạng bị mất]
     │
     ▼
Thao tác ghi ──► Lưu vào Isar + Queue "pending sync"
     │
[Mạng phục hồi]
     │
     ▼
Background Service kiểm tra queue
     │
     ▼
Sync lần lượt các thay đổi lên Firebase
     │
     ▼
Xóa khỏi pending queue + Cập nhật UI
```

---

## 4. Các chức năng cốt lõi

### 4.1 Quản lý Lịch trình (Calendar & Task Management)

| Tính năng | Mô tả | Độ ưu tiên |
|---|---|---|
| Xem lịch theo ngày | Hiển thị chi tiết sự kiện trong ngày | 🔴 Cao |
| Xem lịch theo tuần | Timeline 7 ngày dạng cột | 🔴 Cao |
| Xem lịch theo tháng | Lưới tháng, chấm màu theo danh mục | 🔴 Cao |
| Agenda View | Danh sách sự kiện upcoming | 🟡 Trung bình |
| Thêm / Sửa / Xóa sự kiện | CRUD đầy đủ | 🔴 Cao |
| Phân loại danh mục | Công việc, Học tập, Sức khỏe, Cá nhân | 🔴 Cao |
| Gắn màu sắc | Mã màu tùy chỉnh theo danh mục | 🟡 Trung bình |
| Kiểm tra xung đột giờ | Cảnh báo khi thêm sự kiện trùng giờ | 🟡 Trung bình |

### 4.2 Hệ thống Nhắc nhở (Smart Reminders)

| Tính năng | Mô tả |
|---|---|
| Local Notification | Nhắc trước 5 / 15 / 30 / 60 phút |
| Push Notification | Firebase Cloud Messaging khi app đóng |
| Lịch lặp lại | Hàng ngày / Hàng tuần (chọn thứ) / Hàng tháng |
| Nhắc nhở tùy chỉnh | Người dùng tự cấu hình thời gian nhắc |
| Background Service | Duy trì nhắc nhở khi app không chạy |

**Ví dụ lịch lặp (Recurring Rules):**
```
Lặp hàng tuần vào: [Thứ 2, Thứ 4, Thứ 6]
Lặp đến ngày: 31/12/2025
Nhắc trước: 15 phút
```

### 4.3 Quản lý Tác vụ (To-do / Checklist)

- **Checklist nội tuyến**: Mỗi sự kiện có thể chứa danh sách sub-task
- **Ma trận Eisenhower**: Phân loại theo 4 ô: Quan trọng-Khẩn cấp / Quan trọng-Không khẩn / Không quan trọng-Khẩn cấp / Không quan trọng-Không khẩn
- **Kéo thả sắp xếp**: Thay đổi thứ tự ưu tiên bằng drag & drop
- **Đánh dấu hoàn thành**: Checkbox với animation tick

### 4.4 Thống kê & Báo cáo (Analytics)

| Biểu đồ | Dữ liệu hiển thị |
|---|---|
| Bar Chart (tuần) | Số sự kiện hoàn thành vs tổng theo ngày |
| Pie Chart (tháng) | Tỉ lệ phân bố theo danh mục |
| Streak Calendar | Chuỗi ngày hoàn thành mục tiêu (GitHub-style) |
| Productivity Score | Điểm hiệu suất dựa trên tỉ lệ hoàn thành |

### 4.5 Đồng bộ & Bảo mật

- **Cloud Sync**: Firebase Firestore, real-time listener
- **Multi-device**: Đăng nhập trên nhiều thiết bị, dữ liệu nhất quán
- **Offline Mode**: Isar local DB, tự động sync khi online
- **Biometric Lock**: Vân tay / Face ID bảo vệ app
- **Data Export**: Xuất lịch sang định dạng `.ics` (tương thích Google Calendar)

---

## 5. Thiết kế Cơ sở dữ liệu

### 5.1 Local Database Schema (Isar)

**Collection: Event**
```dart
@Collection()
class Event {
  Id id = Isar.autoIncrement;
  late String remoteId;       // Firebase document ID
  late String title;
  String? description;
  late DateTime startTime;
  late DateTime endTime;
  String? location;
  late String categoryId;
  late int colorHex;
  late bool isAllDay;
  late bool isRecurring;
  String? recurrenceRule;     // RFC 5545 RRULE format
  late List<int> reminderMinutes; // [5, 15, 30]
  late bool isCompleted;
  late bool isSynced;         // Trạng thái đồng bộ
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

**Collection: Category**
```dart
@Collection()
class Category {
  Id id = Isar.autoIncrement;
  late String name;           // "Công việc", "Học tập"
  late int colorHex;
  late String iconCode;       // Flutter icon codepoint
}
```

**Collection: SubTask**
```dart
@Collection()
class SubTask {
  Id id = Isar.autoIncrement;
  late int eventId;
  late String title;
  late bool isCompleted;
  late int sortOrder;
}
```

**Collection: HabitStreak**
```dart
@Collection()
class HabitStreak {
  Id id = Isar.autoIncrement;
  late String habitName;
  late DateTime date;
  late bool isCompleted;
}
```

### 5.2 Remote Database Schema (Firestore)

```
users/
  {userId}/
    profile/          ← Thông tin người dùng
    events/
      {eventId}/      ← Dữ liệu sự kiện
    categories/
      {categoryId}/   ← Danh mục tùy chỉnh
    settings/         ← Cài đặt ứng dụng
```

---

## 6. Màn hình & UI/UX

### 6.1 Danh sách màn hình

| # | Màn hình | Mô tả |
|---|---|---|
| 1 | Splash Screen | Logo + kiểm tra auth |
| 2 | Onboarding | Giới thiệu tính năng (3 slides) |
| 3 | Login / Register | Google, Email/Password |
| 4 | Dashboard (Home) | Tổng quan ngày, widget nhanh |
| 5 | Calendar View | Ngày / Tuần / Tháng / Agenda |
| 6 | Add/Edit Event | Form thêm sự kiện đầy đủ |
| 7 | Event Detail | Chi tiết + checklist sub-task |
| 8 | Task List | To-do với Eisenhower Matrix |
| 9 | Analytics | Biểu đồ thống kê |
| 10 | Settings | Thông báo, bảo mật, tài khoản |
| 11 | Profile | Thông tin người dùng |

### 6.2 Navigation Structure

```
Bottom Navigation Bar:
  [🏠 Home] [📅 Calendar] [✅ Tasks] [📊 Analytics] [⚙️ Settings]
```

### 6.3 Design System

**Color Palette (Light Mode)**
```
Primary:    #6C63FF  (Tím indigo)
Secondary:  #FF6584  (Hồng coral)
Background: #F8F9FA
Surface:    #FFFFFF
Text:       #1A1A2E
Subtext:    #6C757D
```

**Color Palette (Dark Mode)**
```
Primary:    #7B74FF
Background: #121212
Surface:    #1E1E2E
Text:       #E8E8F0
```

**Typography**
```
Font: Google Fonts - Poppins
H1: 24sp Bold
H2: 20sp SemiBold
Body: 14sp Regular
Caption: 12sp Regular
```

**Spacing System**: 4dp base unit (4, 8, 12, 16, 24, 32, 48)

---

## 7. Stack Công nghệ

| Thành phần | Công nghệ | Lý do chọn |
|---|---|---|
| Language | Dart 3.x | Ngôn ngữ chính của Flutter |
| Framework | Flutter 3.x | Cross-platform iOS/Android |
| State Management | Riverpod 2.x | Type-safe, scalable hơn Provider |
| Local DB | Isar 3.x | Nhanh hơn SQLite, NoSQL, full-text search |
| Remote DB | Firebase Firestore | Real-time sync, offline support có sẵn |
| Auth | Firebase Auth | Google Sign-In + Email |
| Notifications | flutter_local_notifications + FCM | Local + Push |
| Calendar UI | table_calendar | Hỗ trợ ngày/tuần/tháng, tùy chỉnh cao |
| Charts | fl_chart | Nhẹ, đẹp, animation mượt |
| Biometric | local_auth | Vân tay / Face ID |
| Networking | Dio | HTTP client có interceptor |
| DI | get_it | Dependency injection đơn giản |
| Navigation | go_router | Declarative routing |
| Localization | flutter_localizations | Đa ngôn ngữ (VI / EN) |
| Icons | Flutter Lucide / Iconsax | Bộ icon hiện đại |

---

## 8. Cấu trúc Thư mục Dự án

```
lib/
├── core/
│   ├── constants/         # Colors, strings, dimensions
│   ├── errors/            # Failure, Exception classes
│   ├── extensions/        # DateTime, String extensions
│   ├── theme/             # AppTheme, TextStyles
│   └── utils/             # Helpers, validators
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── calendar/
│   │   ├── data/
│   │   │   ├── datasources/  # local_datasource, remote_datasource
│   │   │   ├── models/       # EventModel, CategoryModel
│   │   │   └── repositories/ # CalendarRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/     # Event, Category
│   │   │   ├── repositories/ # CalendarRepository (interface)
│   │   │   └── usecases/     # AddEvent, GetEvents, DeleteEvent
│   │   └── presentation/
│   │       ├── blocs/        # CalendarBloc, EventBloc
│   │       ├── pages/        # CalendarPage, EventDetailPage
│   │       └── widgets/      # EventCard, CalendarHeader
│   │
│   ├── tasks/
│   ├── analytics/
│   ├── notifications/
│   └── settings/
│
├── shared/
│   ├── widgets/           # AppButton, AppTextField, LoadingOverlay
│   └── providers/         # Global providers (theme, locale)
│
└── main.dart
```

---

## 9. Các Điểm Mở Rộng

### 9.1 Tích hợp AI (Điểm cộng cao nhất)
**Tính năng**: Người dùng gõ hoặc nói lệnh tự nhiên → AI parse thành sự kiện

```
Input:  "Nhắc tôi họp team lúc 2h chiều thứ 4 tuần sau, trước 15 phút"

Output: {
  title: "Họp team",
  startTime: "2025-XX-XX 14:00",
  category: "Công việc",
  reminder: 15
}
```

**Triển khai**: Gọi API (Gemini / OpenAI) với system prompt phân tích intent → parse JSON response → tự điền form

### 9.2 Home Screen Widget
- Flutter `home_widget` package
- Hiển thị 3 sự kiện gần nhất ngay ngoài màn hình chờ
- Tap để mở thẳng vào sự kiện

### 9.3 Dark Mode
- `ThemeMode.system` theo hệ thống hoặc tự chọn
- Lưu preference vào Isar / SharedPreferences

### 9.4 Xuất / Nhập Lịch
- Export `.ics` → import vào Google Calendar, Apple Calendar
- Import từ Google Calendar qua API

### 9.5 Collaboration (tương lai)
- Chia sẻ sự kiện với người dùng khác
- Lịch nhóm / gia đình

---

## 10. Prompt Thiết kế UI/UX

Sử dụng đoạn prompt sau để tạo bản thiết kế (Figma / UI tools / AI design tools):

---

> **📌 XEM PHẦN CUỐI TÀI LIỆU: DESIGN PROMPT ĐẦY ĐỦ**

*(Prompt được tách riêng ở Section 10 để tiện copy và sử dụng độc lập)*

---

## Phụ lục A: Rủi ro & Giải pháp

| Rủi ro | Mức độ | Giải pháp |
|---|---|---|
| Conflict sync offline/online | Cao | Last-write-wins + timestamp, hiển thị cảnh báo người dùng |
| Notification không hoạt động khi app kill | Cao | Background isolate + FCM fallback |
| Performance với dữ liệu lớn | Trung bình | Isar lazy loading, phân trang, cache |
| Firebase cost vượt free tier | Thấp | Giới hạn sync rate, batch writes |
| Biometric không hỗ trợ thiết bị cũ | Thấp | Fallback về PIN/Password |

---

## Phụ lục B: Checklist Triển khai

### Phase 1 — Foundation (Tuần 1-2)
- [ ] Setup project Flutter, cấu hình clean architecture
- [ ] Tích hợp Firebase (Auth, Firestore)
- [ ] Setup Isar local database
- [ ] Riverpod state management cơ bản
- [ ] Theme & Design System (màu, font, spacing)

### Phase 2 — Core Features (Tuần 3-5)
- [ ] Màn hình Calendar (ngày/tuần/tháng)
- [ ] CRUD sự kiện đầy đủ
- [ ] Danh mục & màu sắc
- [ ] Local notifications
- [ ] Offline support + sync queue

### Phase 3 — Advanced (Tuần 6-8)
- [ ] To-do list + Eisenhower Matrix
- [ ] Recurring events
- [ ] Analytics & biểu đồ
- [ ] Biometric lock
- [ ] Dark mode

### Phase 4 — Polish & Extension (Tuần 9-10)
- [ ] AI natural language parsing (nếu có)
- [ ] Home screen widget
- [ ] Export .ics
- [ ] Testing (unit + widget + integration)
- [ ] Performance optimization

---

*Tài liệu này là đặc tả đầy đủ cho hệ thống Personal Scheduler App, sẵn sàng dùng làm căn cứ thiết kế và phát triển.*
