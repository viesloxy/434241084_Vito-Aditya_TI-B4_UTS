# Admin Settings

## Overview

Halaman Pengaturan untuk **Admin** yang memungkinkan mengelola pengaturan aplikasi, kategori tiket, dan informasi akun admin.

> **Catatan**: Halaman ini khusus untuk role Admin. Untuk pengaturan Helpdesk, lihat [../helpdesk/05-helpdesk-profile.md](../helpdesk/05-helpdesk-profile.md).

## Visual Design

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#4F46E5` | Buttons, links |
| Background | `#F3F4F6` | Page background |
| Surface | `#FFFFFF` | Cards, containers |
| Text Primary | `#111827` | Headings |
| Text Secondary | `#6B7280` | Labels |
| Border | `#E5E7EB` | Dividers |

## Layout Structure

```
┌─────────────────────────────────────┐
│ Header                              │
│ [←] Pengaturan           [🔍] [👤] │
├─────────────────────────────────────┤
│ Account Section                      │
│ ┌─────────────────────────────────┐ │
│ │ 👤 Admin                        │ │
│ │    Sarah@university.ac          │ │
│ │    Administrator                │ │
│ │    [Lihat Profil →]            │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Application Settings                 │
│ ┌─────────────────────────────────┐ │
│ │ 🔔 Notifikasi          [ON ]   │ │
│ │ 🌙 Tema Aplikasi        [OFF]  │ │
│ │ 🌍 Bahasa          [Indonesia] │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Ticket Settings                     │
│ ┌─────────────────────────────────┐ │
│ │ 📁 Kelola Kategori        [→]  │ │
│ │ ⏰ Auto Assignment       [ON ]  │ │
│ │ 📊 SLA Settings          [→]  │ │
│ │ 📧 Email Templates       [→]  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ System                              │
│ ┌─────────────────────────────────┐ │
│ │ 🔒 Kebijakan Privasi      [→]  │ │
│ │ 📄 Syarat & Ketentuan     [→]  │ │
│ │ ℹ️  Tentang Aplikasi       [→]  │ │
│ │ 🆘 Pusat Bantuan          [→]  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Version Info                         │
│ v1.0.0 • Build 2024.03.21          │
├─────────────────────────────────────┤
│ [            Keluar              ] │
└─────────────────────────────────────┘
```

## Features & Interactions

### 1. Account Section

**Display:**
- Avatar with initial
- Name
- Email
- Role badge

**Interaction:**
- Tap → Navigate to admin profile

### 2. Application Settings

#### Notification Toggle
| Setting | Description |
|---------|-------------|
| Notifikasi | Enable/disable push notifications |
| Sound | Enable/disable notification sound |
| Vibration | Enable/disable vibration |

#### Theme Selector
| Option | Description |
|--------|-------------|
| Light | Light mode |
| Dark | Dark mode (future) |
| System | Follow system setting |

#### Language Selector
| Option | Description |
|--------|-------------|
| Indonesia | Bahasa Indonesia |
| English | English (future) |

### 3. Ticket Settings

#### Kategori Management
Navigate to category management page.

**Category Management Page:**
```
┌─────────────────────────────────────┐
│ [←] Kelola Kategori        [➕]   │
├─────────────────────────────────────┤
│ Category List                       │
│ ┌─────────────────────────────────┐ │
│ │ 📚 Akademik          [✏️] [🗑] │ │
│ │ 💻 Teknologi         [✏️] [🗑] │ │
│ │ 🏢 Fasilitas         [✏️] [🗑] │ │
│ │ 💰 Keuangan          [✏️] [🗑] │ │
│ │ ⋯ Lainnya           [✏️] [🗑] │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

**Add/Edit Category Modal:**
```
┌─────────────────────────────────────┐
│ [Tambah/Edit] Kategori              │
├─────────────────────────────────────┤
│ Nama Kategori:                      │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Icon:                               │
│ [📚] [💻] [🏢] [💰] [📋] [🔧]     │
│                                     │
│ Warna:                              │
│ [●] [●] [●] [●] [●]               │
│                                     │
│ Status:                             │
│ [Aktif ▼]                          │
│                                     │
│        [Batal]  [Simpan]            │
└─────────────────────────────────────┘
```

**Interaction:**
- Tap edit → Edit category modal
- Tap delete → Confirmation dialog
- Tap add → Add category modal

#### Auto Assignment
| Setting | Description |
|---------|-------------|
| Enable | Automatically assign new tickets to available staff |
| Algorithm | Round-robin / Load-balanced / By category |

#### SLA Settings
Configure Service Level Agreement:

| Priority | Response Time | Resolution Time |
|----------|---------------|----------------|
| Tinggi | 15 menit | 1 jam |
| Sedang | 1 jam | 4 jam |
| Rendah | 4 jam | 24 jam |

### 4. System Settings

#### Privacy Policy
Navigate to privacy policy page.

#### Terms & Conditions
Navigate to terms page.

#### About Application
```
┌─────────────────────────────────────┐
│ [←] Tentang Aplikasi                 │
├─────────────────────────────────────┤
│                                     │
│         📱                          │
│                                     │
│     E-Ticketing Helpdesk            │
│     Mobile App                      │
│                                     │
│     Version 1.0.0                  │
│     Build 2024.03.21                │
│                                     │
│     © 2024 Universitas              │
│     All rights reserved             │
│                                     │
└─────────────────────────────────────┘
```

#### Help Center
Navigate to FAQ/Help page.

### 5. Logout Button

**Confirmation Dialog:**
```
┌─────────────────────────────────────┐
│ ⚠️  Konfirmasi                       │
├─────────────────────────────────────┤
│                                     │
│    Apakah Anda yakin ingin          │
│    keluar dari akun ini?             │
│                                     │
│        [Batal]  [Keluar]            │
│                                     │
└─────────────────────────────────────┘
```

## States

### Loading State
- Skeleton for settings list

### Error State
- "Gagal memuat pengaturan"
- Retry button

### Success States
- Settings saved: Snackbar confirmation
- Category added: Snackbar + list update
- Logout: Navigate to login

## Technical Requirements

### Navigation
- `/admin/settings` - Settings page
- `/admin/settings/categories` - Category management
- `/admin/settings/sla` - SLA settings
- `/admin/profile` - Admin profile

### Data Model
```dart
class AppSettings {
  bool notificationsEnabled;
  bool soundEnabled;
  bool vibrationEnabled;
  String theme; // light, dark, system
  String language; // id, en
  bool autoAssignmentEnabled;
  String assignmentAlgorithm; // round_robin, load_balance, by_category
  Map<String, SLAConfig> slaConfig;
}

class SLAConfig {
  int responseMinutes;
  int resolutionMinutes;
}

class Category {
  String id;
  String name;
  String icon;
  String color;
  bool isActive;
  int ticketCount;
  DateTime createdAt;
}

class AdminProfile {
  String id;
  String name;
  String email;
  String role;
  String? avatar;
  DateTime lastLogin;
}
```

### API Endpoints (Mock)
- `GET /settings` - Get app settings
- `PUT /settings` - Update settings
- `GET /categories` - Get categories
- `POST /categories` - Create category
- `PUT /categories/:id` - Update category
- `DELETE /categories/:id` - Delete category
- `GET /sla` - Get SLA config
- `PUT /sla` - Update SLA config

## Dependencies

### Required Pages
- SettingsPage
- CategoryManagementPage
- EditCategoryPage
- AdminProfilePage
- HelpCenterPage

### Required Widgets
- SettingsSection
- ToggleSetting
- SelectSetting
- CategoryListItem
- ConfirmDialog