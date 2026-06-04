# Admin Dashboard

## Overview

Halaman Dashboard adalah halaman utama untuk role **Admin** yang menampilkan overview statistik global sistem, data tiket terbaru dari semua user, dan quick actions. Halaman ini berfungsi sebagai central hub untuk monitoring keseluruhan aktivitas helpdesk.

> **Catatan Revisi**: Halaman dashboard Admin hanya menampilkan data **global** (semua tiket dari semua user). Dashboard Helpdesk (lihat [../helpdesk/01-helpdesk-dashboard.md](../helpdesk/01-helpdesk-dashboard.md)) menampilkan data **personal** (tiket yang di-assign ke Helpdesk tersebut).

## Visual Design

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#4F46E5` | Navigation, active states, buttons |
| Background | `#F3F4F6` | Page background |
| Surface | `#FFFFFF` | Cards, containers |
| Text Primary | `#111827` | Headings, important text |
| Text Secondary | `#6B7280` | Labels, descriptions |
| Success | `#10B981` | Completed tickets, positive stats |
| Warning | `#F59E0B` | Pending tickets |
| Error | `#EF4444` | High priority, rejected |
| Info | `#3B82F6` | In-progress tickets |

### Typography

| Element | Font | Size | Weight |
|---------|------|------|--------|
| Page Title | Inter | 24px | 700 |
| Section Title | Inter | 18px | 600 |
| Card Title | Inter | 16px | 600 |
| Body Text | Inter | 14px | 400 |
| Caption | Inter | 12px | 400 |

## Layout Structure

```
┌─────────────────────────────────────┐
│ Header                              │
│ - Admin name & role badge          │
│ - Search icon                       │
│ - Profile avatar                    │
├─────────────────────────────────────┤
│ Quick Stats Cards (2x2 Grid)        │
│ ┌─────────┐ ┌─────────┐             │
│ │ Total   │ │ Tiket   │             │
│ │ Tiket   │ │ Baru    │             │
│ └─────────┘ └─────────┘             │
│ ┌─────────┐ ┌─────────┐             │
│ │ Sedang  │ │ Selesai │             │
│ │ Proses  │ │ (Closed)│             │
│ └─────────┘ └─────────┘             │
├─────────────────────────────────────┤
│ Tiket Masuk (Submitted)             │
│ [Daftar tiket Submitted yang       │
│  perlu di-assign]                   │
├─────────────────────────────────────┤
│ Performa Helpdesk                   │
│ [Tabel performa masing-masing      │
│  Helpdesk]                          │
├─────────────────────────────────────┤
│ Tiket Terbaru (Semua Status)        │
│ [5 tiket terbaru]                  │
├─────────────────────────────────────┤
│ Admin Bottom Navigation             │
└─────────────────────────────────────┘
```

## Features & Interactions

### 1. Header Section

| Element | Description |
|---------|-------------|
| Greeting Text | "Selamat datang, [Nama Admin]" |
| Role Badge | "Administrator" (warna primary) |
| Search Button | Icon search, navigasi ke halaman pencarian |
| Profile Avatar | CircleAvatar dengan inisial, navigasi ke profil |

### 2. Quick Stats Cards (Statistik Global)

| Stat Card | Data | Color |
|-----------|------|-------|
| Total Tiket | Counter semua tiket (semua status) | Primary (#4F46E5) |
| Tiket Baru | Tiket berstatus `Submitted` (perlu di-assign) | Warning (#F59E0B) |
| Sedang Diproses | Tiket berstatus `Signed/Assigned` atau `In Progress` | Info (#3B82F6) |
| Selesai | Tiket berstatus `Resolved` (menunggu konfirmasi user) | Success (#10B981) |

**Interaction:**
- Tap on card → Navigasi ke filtered ticket list berdasarkan status
- Pull to refresh → Update data statistik

### 3. Tiket Masuk (Prioritas Utama)

Menampilkan tiket dengan status `Submitted` yang **perlu di-assign ke Helpdesk**.

| Element | Description |
|---------|-------------|
| Title | "Tiket Masuk" dengan badge count |
| List | Daftar tiket `Submitted` terbaru |
| Action | Quick action "Assign" langsung dari card |
| Empty State | "Tidak ada tiket masuk baru" |

**Interaction:**
- Tap card → Navigasi ke `/admin/ticket-detail/:id`
- Tap "Assign" → Langsung buka modal assign Helpdesk

### 4. Performa Helpdesk

Mini-table performa Helpdesk:

| Column | Content |
|--------|---------|
| Nama | Nama Helpdesk dengan avatar |
| Tiket Aktif | Jumlah tiket `Signed/Assigned` + `In Progress` |
| Selesai | Jumlah tiket `Closed` |
| Rata-rata Waktu | Avg resolution time |

**Interaction:**
- Tap row → Navigasi ke filtered ticket list per Helpdesk

### 5. Tiket Terbaru

Menampilkan 5 tiket terbaru dari semua user dengan info:
- Ticket ID
- Judul Tiket
- Kategori (badge)
- Status (badge)
- Prioritas (badge)
- Assigned Helpdesk (jika ada)
- Waktu pembuatan

**Interaction:**
- Tap card → Navigasi ke `/admin/ticket-detail/:id`

### 6. Bottom Navigation

| Tab | Icon (default) | Icon (active) |
|-----|----------------|---------------|
| Dashboard | `home_outlined` | `home` |
| Tiket | `description_outlined` | `description` |
| Notifikasi | `notifications_outlined` | `notifications` |
| Profil | `person_outline` | `person` |

## States

### Loading State
- Skeleton cards untuk statistik
- Shimmer effect untuk list

### Empty State
- Ilustrasi empty box
- Text: "Belum ada tiket"
- CTA button: "Refresh"

### Error State
- Error illustration
- "Gagal memuat data"
- Retry button

## Perbedaan dengan Dashboard Helpdesk

| Aspek | Admin Dashboard | Helpdesk Dashboard |
|-------|-----------------|---------------------|
| Scope data | Global (semua tiket) | Personal (tiket assigned ke Helpdesk) |
| Stats | Total tiket semua user | Total tiket yang di-assign ke Helpdesk |
| Tiket masuk | `Submitted` (perlu di-assign) | `Signed/Assigned` (siap dikerjakan) |
| Aksi utama | Assign tiket ke Helpdesk | Mulai kerjakan tiket |
| Performa | Performa semua Helpdesk | Tidak ada (atau performa personal) |
| Statistik | Global + komprehensif | Personal |

## Technical Requirements

### Navigation Routes
- `/admin` - Admin Dashboard
- `/admin/tickets` - Daftar Tiket
- `/admin/ticket/:id` - Detail Tiket
- `/admin/users` - Manajemen User
- `/admin/statistics` - Laporan
- `/admin/profile` - Profil Admin

### Data Requirements
```dart
// Stats Data (Global)
{
  totalTickets: int,
  submittedTickets: int,     // Perlu di-assign
  activeTickets: int,         // Signed/Assigned + In Progress
  resolvedTickets: int,       // Menunggu konfirmasi user
  closedTickets: int,         // Final
}

// Recent Tickets (Semua status)
{
  id: String,
  ticketId: String,
  title: String,
  category: String,
  status: String,             // submitted, signed_assigned, in_progress, resolved, closed
  createdAt: DateTime,
  priority: String,
  assignedTo: String?,        // Helpdesk name (jika sudah di-assign)
  createdBy: String,          // User name
}

// Helpdesk Performance
{
  helpdeskId: String,
  helpdeskName: String,
  activeTickets: int,
  closedTickets: int,
  avgResolutionHours: double,
}
```

### Responsive Behavior
- Mobile-first design
- Max width: 480px
- Card grid: 2 columns on mobile

## Dependencies

### Required Pages
- AdminDashboardPage
- TicketListPage
- TicketDetailPage
- NotificationsPage
- ProfilePage

### Required Widgets
- StatCard
- CategoryChip
- TicketListItem
- AdminBottomNavBar
- SearchBar
- HelpdeskPerformanceTable

### Required Services
- TicketService (get global stats, get all recent tickets)
- AuthService (get admin profile)
- NotificationService
- HelpdeskService (get helpdesk performance)
