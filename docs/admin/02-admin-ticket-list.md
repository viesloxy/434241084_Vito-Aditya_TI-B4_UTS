# Admin Ticket List

## Overview

Halaman Daftar Tiket untuk **Admin** yang menampilkan **semua tiket** yang masuk dari semua user dengan fitur filter, pencarian, dan bulk actions. Admin dapat melihat, mencari, menugaskan, dan mengelola semua tiket dari halaman ini.

> **Catatan Revisi**: Halaman ini khusus untuk Admin. Untuk Helpdesk yang hanya melihat tiket yang di-assign, lihat [../helpdesk/02-helpdesk-task-list.md](../helpdesk/02-helpdesk-task-list.md).

## Visual Design

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#4F46E5` | Buttons, active states |
| Background | `#F3F4F6` | Page background |
| Surface | `#FFFFFF` | Cards, list items |
| Text Primary | `#111827` | Headings |
| Text Secondary | `#6B7280` | Labels, timestamps |
| Border | `#E5E7EB` | Dividers, borders |

## Layout Structure

```
┌─────────────────────────────────────┐
│ Header                              │
│ [←] Daftar Tiket        [🔍] [⚙️] │
├─────────────────────────────────────┤
│ Filter Chips (Horizontal)           │
│ [Semua] [Submitted] [Signed]        │
│ [InProgress] [Resolved] [Closed]    │
├─────────────────────────────────────┤
│ Search Bar                          │
│ [🔍  Cari tiket...]                  │
├─────────────────────────────────────┤
│ Sort: [Terbaru ▼]  [📋] [⋮]        │
├─────────────────────────────────────┤
│ Ticket List                          │
│ ┌─────────────────────────────────┐ │
│ │ #TK-001 - Reset Password         │ │
│ │ Teknologi | Submitted | 10:00    │ │
│ │ John Doe (Mahasiswa)            │ │
│ │ [⚡ Tinggi] [Assign →]          │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Admin Bottom Navigation              │
└─────────────────────────────────────┘
```

## Status Tiket (Setelah Revisi 3 Role)

| Status | Value | Color | Deskripsi |
|--------|-------|-------|-----------|
| Submitted | `submitted` | Warning (#F59E0B) | Tiket baru, perlu di-assign Admin |
| Signed/Assigned | `signed_assigned` | Info (#3B82F6) | Sudah di-assign ke Helpdesk |
| In Progress | `in_progress` | Primary (#4F46E5) | Helpdesk sedang kerjakan |
| Resolved | `resolved` | Success (#10B981) | Helpdesk selesai, menunggu konfirmasi User |
| Closed | `closed` | Gray (#6B7280) | Sudah ditutup Admin (final) |
| Ditolak | `rejected` | Error (#EF4444) | Tiket ditolak |

## Features & Interactions

### 1. Header

| Element | Action |
|---------|--------|
| Back Button | Kembali ke halaman sebelumnya |
| Title | "Daftar Tiket" |
| Search Button | Toggle search mode |
| Filter Button | Toggle filter modal |

### 2. Filter Chips

Horizontal scrollable chips untuk filter status:

| Chip | Status Value | Color |
|------|--------------|-------|
| Semua | `all` | Neutral |
| Submitted | `submitted` | Warning |
| Signed/Assigned | `signed_assigned` | Info |
| In Progress | `in_progress` | Primary |
| Resolved | `resolved` | Success |
| Closed | `closed` | Gray |
| Ditolak | `rejected` | Error |

**Interaction:**
- Tap chip → Filter list berdasarkan status
- Active chip memiliki background solid

### 3. Search Bar

- Search by: Ticket ID, Title, Description, Creator Name, Assigned Helpdesk Name
- Debounce: 300ms
- Clear search: X button or cancel

### 4. Sort & View Options

| Option | Values |
|--------|--------|
| Sort By | Tanggal, Prioritas, Status |
| Order | Terbaru, Terlama |
| View | List, Grid (future) |

### 5. Bulk Actions (Hanya Assign, Bukan Tandai Selesai)

> **Penting**: Setelah revisi, Admin **tidak bisa** "Tandai Selesai" tiket secara langsung. Itu adalah tugas Helpdesk. Bulk action Admin hanya untuk assignment.

When user long-presses a ticket, enters selection mode:

| Action | Icon | Description |
|--------|------|-------------|
| Select All | `✓` | Select all visible tickets |
| Assign to Helpdesk | `person` | **Assign tiket ke Helpdesk** |
| Delete | `🗑` | Delete selected (admin only, dengan konfirmasi) |

### 6. Ticket List Item

Each ticket card displays:

| Field | Value |
|-------|-------|
| Ticket ID | Format: #TK-YYYY-NNN |
| Title | Max 2 lines, ellipsis overflow |
| Category | Badge with icon |
| Status | Status badge |
| Time | "X waktu yang lalu" |
| Assigned To | Helpdesk name or "Belum ditugaskan" |
| Priority | High/Medium/Low badge |
| Created By | User name |

**Ticket Card States:**
- Default: White background
- Selected: Light primary background + checkmark
- Swiped: Reveal quick actions

**Interactions:**
- Tap → Navigate to `/admin/ticket-detail/:id`
- Long press → Enter selection mode
- Swipe left → Quick action (assign)

### 7. Empty State

```
┌─────────────────────────────────────┐
│                                     │
│        📋                          │
│                                     │
│    Tidak ada tiket                  │
│    yang sesuai filter               │
│                                     │
│    [Reset Filter]                   │
│                                     │
└─────────────────────────────────────┘
```

### 8. Pull to Refresh
- Visual: CircularProgressIndicator at top
- Behavior: Fetch latest data from API

### 9. Pagination
- Infinite scroll
- Load more when 80% scrolled
- Loading indicator at bottom

## Perbedaan dengan Task List Helpdesk

| Aspek | Admin Ticket List | Helpdesk Task List |
|-------|-------------------|---------------------|
| Scope | Semua tiket dari semua user | Hanya tiket yang di-assign ke Helpdesk |
| Filter | Semua status (5 status + ditolak) | Hanya `signed_assigned`, `in_progress`, `resolved` |
| Quick Action | "Assign ke Helpdesk" | "Mulai Kerjakan" / "Selesaikan" |
| Bulk Action | Assign to Helpdesk, Delete | (Tidak ada, masing-masing tiket punya aksi sendiri) |
| Default Filter | "Submitted" (perlu di-assign) | "Signed/Assigned" (perlu dikerjakan) |

## Technical Requirements

### Navigation
- `/admin/tickets` - Main ticket list
- `/admin/ticket/:id` - Ticket detail

### Query Parameters
```
/admin/tickets?status=submitted&category=teknologi&search=password
```

### Data Model
```dart
class Ticket {
  String id;
  String ticketId;        // Format: #TK-YYYY-NNN
  String title;
  String description;
  String category;        // akademik, teknologi, fasilitas, keuangan, lainnya
  String status;          // submitted, signed_assigned, in_progress, resolved, closed, rejected
  String priority;        // tinggi, sedang, rendah
  String? assignedTo;     // Helpdesk name (null jika belum di-assign)
  String createdBy;       // User name
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? resolvedAt;
  DateTime? closedAt;
}
```

### API Endpoints (Mock)
- `GET /admin/tickets?status=&category=&search=&page=&limit=` - Get all tickets with filters
- `POST /admin/tickets/bulk-assign` - Bulk assign tickets
- `DELETE /admin/tickets/bulk` - Bulk delete

## Dependencies

### Required Pages
- AdminTicketListPage
- AdminTicketDetailPage

### Required Widgets
- AdminTicketCard
- FilterChips
- SearchBar
- SortDropdown
- BulkActionBar

### Required Services
- TicketService (admin scope)
- HelpdeskService (get available helpdesks for assignment)
