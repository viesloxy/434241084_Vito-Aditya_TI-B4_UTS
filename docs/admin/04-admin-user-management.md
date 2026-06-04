# Admin User Management

## Overview

Halaman Manajemen User untuk **Admin** yang memungkinkan mengelola data pengguna (mahasiswa, staff helpdesk, dan admin lain) termasuk melihat detail, mengedit role, dan mengatur status akun.

> **Catatan Revisi**: Role yang dikelola:
> - `user` (mahasiswa/staff) - bisa membuat tiket
> - `helpdesk` (petugas support) - mengerjakan tiket yang di-assign
> - `admin` (pengelola sistem) - assign tiket, close tiket, manage user
> 
> Untuk detail Helpdesk, lihat [../helpdesk/README.md](../helpdesk/README.md).

## Visual Design

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#4F46E5` | Buttons, links |
| Background | `#F3F4F6` | Page background |
| Surface | `#FFFFFF` | Cards, tables |
| Text Primary | `#111827` | Headings |
| Text Secondary | `#6B7280` | Labels |
| Success | `#10B981` | Active status |
| Warning | `#F59E0B` | Pending status |
| Error | `#EF4444` | Inactive/Blocked |

## Layout Structure

```
┌─────────────────────────────────────┐
│ Header                              │
│ [←] Manajemen User     [🔍] [➕]    │
├─────────────────────────────────────┤
│ Tab Filter                           │
│ [Semua] [User] [Helpdesk] [Admin]   │
├─────────────────────────────────────┤
│ Search Bar                           │
│ [🔍  Cari nama, NIM/NIP, email...]  │
├─────────────────────────────────────┤
│ Stats Summary                        │
│ Total: 150 | Aktif: 140 | Pending: 10│
├─────────────────────────────────────┤
│ User List                             │
│ ┌─────────────────────────────────┐ │
│ │ 👤 John Doe (User/Mahasiswa)   │ │
│ │    NIM: 12345678 | Aktif       │ │
│ │    john@university.ac          │ │
│ │    [⋯]                         │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 👤 Sarah Helpdesk               │ │
│ │    NIP: 98765432 | Aktif       │ │
│ │    sarah@university.ac          │ │
│ │    [Helpdesk] [⋯]              │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 👤 Ahmad Admin                  │ │
│ │    NIP: 11111111 | Aktif       │ │
│ │    ahmad@university.ac          │ │
│ │    [Admin] [⋯]                 │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Admin Bottom Navigation              │
└─────────────────────────────────────┘
```

## Features & Interactions

### 1. Header

| Element | Action |
|---------|--------|
| Back Button | Kembali |
| Title | "Manajemen User" |
| Search Button | Toggle search |
| Add Button | Navigate to add user form |

### 2. Tab Filter

Horizontal tabs for filtering by role:

| Tab | Role Value | Count Badge |
|-----|------------|-------------|
| Semua | `all` | Total users |
| User | `user` | User count (mahasiswa/staff) |
| Helpdesk | `helpdesk` | Helpdesk count |
| Admin | `admin` | Admin count |

### 3. Search Bar

- Placeholder: "Cari nama, NIM/NIP, atau email..."
- Search debounce: 300ms
- Clear button when text exists

### 4. Stats Summary

Quick stats row showing:
- Total Users (semua role)
- Active Users
- Pending Approval

### 5. User List

**User Card Display:**

| Field | Value |
|-------|-------|
| Avatar | CircleAvatar with initial |
| Name | Full name |
| ID Number | NIM (untuk User/mahasiswa) / NIP (untuk Helpdesk & Admin) |
| Email | User email |
| Role | Role badge |
| Status | Active/Pending/Inactive |

**Role Badges (3 Role Setelah Revisi):**

| Role | Color | Text | Keterangan |
|------|-------|------|------------|
| Admin | Primary (#4F46E5) | "Admin" | Pengelola sistem |
| Helpdesk | Info (#3B82F6) | "Helpdesk" | Petugas support |
| User | Gray (#6B7280) | "User" | Mahasiswa/Staff pelapor |

**Status Badges:**

| Status | Color |
|--------|-------|
| Aktif | Success (#10B981) |
| Pending | Warning (#F59E0B) |
| Nonaktif | Error (#EF4444) |
| Cuti (Helpdesk) | Warning (#F59E0B) |

### 6. User Actions

Tap "more" button (⋮) on user card to show actions:

| Action | Icon | Description |
|--------|------|-------------|
| Lihat Detail | `visibility` | Navigate to user detail |
| Edit User | `edit` | Edit user data |
| Ubah Role | `badge` | Change user role (User ↔ Helpdesk ↔ Admin) |
| Reset Password | `lock_reset` | Send reset password |
| Nonaktifkan | `block` | Deactivate user account |
| Hapus | `delete` | Delete user (admin only) |

### 7. Add/Edit User Modal

```
┌─────────────────────────────────────┐
│ Tambah User                         │
├─────────────────────────────────────┤
│ Nama Lengkap:                       │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Email:                              │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ NIM/NIP:                            │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Role:                               │
│ [User ▼] (User/Helpdesk/Admin)     │
│                                     │
│ Departemen (untuk Helpdesk):        │
│ [Dropdown: IT, Fasilitas, dll]      │
│                                     │
│ Status:                             │
│ [Aktif ▼]                          │
│                                     │
│        [Batal]  [Simpan]            │
└─────────────────────────────────────┘
```

### 8. User Detail Page

```
┌─────────────────────────────────────┐
│ [←] Detail User         [✏️] [⋮]   │
├─────────────────────────────────────┤
│ Profile Card                        │
│ ┌─────────────────────────────────┐ │
│ │     👤                         │ │
│ │     John Doe                   │ │
│ │     john@university.ac        │ │
│ │     [User] [Aktif]             │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ User Information                    │
│ ┌─────────────────────────────────┐ │
│ │ Nama:      John Doe             │ │
│ │ Email:     john@university.ac  │ │
│ │ NIM:       12345678             │ │
│ │ Jurusan:   Informatika          │ │
│ │ Role:      User (Mahasiswa)     │ │
│ │ Status:    Aktif                │ │
│ │ Terdaftar: 15 Jan 2024          │ │
│ │ Login Ter: 20 Apr 2024, 10:00  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Tiket yang Dibuat (jika User)       │
│ ┌─────────────────────────────────┐ │
│ │ #TK-001 | Reset Password        │ │
│ │ #TK-002 | Jadwal Ujian          │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Tiket yang Ditangani (jika Helpdesk)│
│ ┌─────────────────────────────────┐ │
│ │ #TK-005 | AC Rusak              │ │
│ │ #TK-007 | Internet Mati         │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Actions                             │
│ [Ubah Role] [Reset Password]        │
│ [Nonaktifkan]                       │
└─────────────────────────────────────┘
```

## States

### Loading State
- Skeleton cards
- Shimmer effect

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│        👤                          │
│                                     │
│    Tidak ada pengguna               │
│    yang ditemukan                   │
│                                     │
│    [Reset Pencarian]               │
│                                     │
└─────────────────────────────────────┘
```

### Error State
- "Gagal memuat data pengguna"
- Retry button

## Technical Requirements

### Navigation
- `/admin/users` - User list
- `/admin/users/:id` - User detail
- `/admin/users/add` - Add user form

### Query Parameters
```
/admin/users?role=helpdesk&search=john
```

### Data Model
```dart
class User {
  String id;
  String name;
  String email;
  String nimNip;         // NIM untuk user/mahasiswa, NIP untuk helpdesk/admin
  String role;           // admin, helpdesk, user (3 role setelah revisi)
  String status;         // aktif, pending, nonaktif, cuti (cuti khusus helpdesk)
  String? department;    // Untuk Helpdesk: IT, Fasilitas, Akademik, Keuangan
  String? studyProgram;  // Untuk User (Mahasiswa): Informatika, dll
  DateTime createdAt;
  DateTime? lastLoginAt;
  int ticketCount;       // Number of tickets created (untuk User)
  int assignedCount;     // Number of tickets assigned (untuk Helpdesk)
}
```

### API Endpoints (Mock)
- `GET /admin/users?role=&search=&page=&limit=` - Get users with filters
- `GET /admin/users/:id` - Get single user
- `POST /admin/users` - Create user
- `PUT /admin/users/:id` - Update user
- `PUT /admin/users/:id/role` - Change user role
- `PUT /admin/users/:id/status` - Change user status
- `DELETE /admin/users/:id` - Delete user
- `POST /admin/users/:id/reset-password` - Send reset password email

### Permissions

| Action | Admin | Helpdesk | User |
|--------|-------|----------|------|
| View Users | ✅ | Limited (hanya lihat helpdesk lain) | ❌ |
| Add User | ✅ | ❌ | ❌ |
| Edit User | ✅ | Limited (edit profil sendiri) | Edit profil sendiri |
| Change Role | ✅ | ❌ | ❌ |
| Delete User | ✅ | ❌ | ❌ |
| Deactivate User | ✅ | ❌ | ❌ |

## Dependencies

### Required Pages
- UserListPage
- UserDetailPage
- AddUserPage
- EditUserPage

### Required Widgets
- UserCard
- RoleBadge (3 role: admin, helpdesk, user)
- StatusBadge
- UserAvatar
- SearchBar
- FilterTabs
- ActionMenu
- UserDetailCard
