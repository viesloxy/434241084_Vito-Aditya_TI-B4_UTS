# Admin Ticket Detail

## Overview

Halaman Detail Tiket untuk **Admin** yang menampilkan informasi lengkap tiket beserta fitur untuk **assign tiket ke Helpdesk**, **balas komentar**, dan **close tiket** setelah User konfirmasi.

> **Catatan Revisi (PENTING)**: 
> - Setelah revisi 3 role, Admin **HANYA** bisa melakukan 2 perubahan status:
>   1. `Submitted` → `Signed/Assigned` (assign ke Helpdesk)
>   2. `Resolved` → `Closed` (setelah User konfirmasi)
> - Admin **TIDAK BOLEH** mengubah status ke `In Progress` atau `Resolved` (tugas Helpdesk).
> - Untuk detail tiket Helpdesk, lihat [../helpdesk/03-helpdesk-task-detail.md](../helpdesk/03-helpdesk-task-detail.md).

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
│ App Bar                             │
│ [←] #TK-2024-001      [📤] [⋮]     │
├─────────────────────────────────────┤
│ Ticket Header Card                  │
│ ┌─────────────────────────────────┐ │
│ │ Permintaan Reset Password       │ │
│ │ [Akademik] [Submitted] [⚡Tinggi]│ │
│ │ Dibuat: 21 Jan 2024, 10:00     │ │
│ │ Oleh: John Doe (Mahasiswa)      │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Status Timeline                     │
│ ┌─────────────────────────────────┐ │
│ │ ✓ Submitted         10:00       │ │
│ │ ○ Signed/Assigned   -           │ │
│ │ ○ In Progress       -           │ │
│ │ ○ Resolved          -           │ │
│ │ ○ Closed            -           │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Ticket Details                      │
│ ┌─────────────────────────────────┐ │
│ │ Pembuat:    John Doe (Mahasiswa)│ │
│ │ Email:      john@university.ac  │ │
│ │ Prioritas:  Tinggi              │ │
│ │ Ditugaskan: [Sarah - Helpdesk]  │ │
│ │ Tanggal Dibuat: 21 Jan 10:00    │ │
│ │ Terakhir Update: 21 Jan 10:00   │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Description                          │
│ ┌─────────────────────────────────┐ │
│ │ Deskripsi lengkap tiket...     │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Attachments                         │
├─────────────────────────────────────┤
│ Conversation / Chat                  │
├─────────────────────────────────────┤
│ Action Buttons (Sesuai Status)      │
│ ┌─────────────────────────────────┐ │
│ │ IF status = Submitted:          │ │
│ │   [Assign ke Helpdesk]          │ │
│ │                                 │ │
│ │ IF status = Signed/Assigned:    │ │
│ │   [Batalkan Assignment]         │ │
│ │                                 │ │
│ │ IF status = Resolved:           │ │
│ │   [Close Tiket]                 │ │
│ │                                 │ │
│ │ IF status = In Progress:        │ │
│ │   (tidak ada action)            │ │
│ │   (tunggu Helpdesk selesaikan)  │ │
│ │                                 │ │
│ │ IF status = Closed:             │ │
│ │   (read-only)                   │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Message Input                        │
│ [ 📎 ] [ Ketik pesan...      ] [➤] │
└─────────────────────────────────────┘
```

## Status & Aksi yang Tersedia untuk Admin

| Status | Aksi yang Tersedia | Tombol |
|--------|---------------------|--------|
| `Submitted` | Assign ke Helpdesk | "Assign ke Helpdesk" |
| `Signed/Assigned` | Batalkan assignment (jika Helpdesk berhalangan) | "Batalkan Assignment" |
| `In Progress` | **TIDAK ADA** (tunggu Helpdesk) | - |
| `Resolved` | Close tiket (setelah User konfirmasi) | "Close Tiket" |
| `Closed` | Read-only (status final) | - |

## Features & Interactions

### 1. App Bar

| Element | Action |
|---------|--------|
| Back Button | Kembali ke daftar tiket |
| Title | Ticket ID (#TK-YYYY-NNN) |
| Share | Share ticket info |
| More Menu | Edit, Delete, Print |

### 2. Ticket Header Card

Displays primary ticket information:
- Title (max 2 lines)
- Category badge
- Status badge
- Priority badge
- Created timestamp
- Created by (User)

### 3. Status Timeline

Visual representation of ticket lifecycle (5 stages):

| Status | Icon | Color |
|--------|------|-------|
| Submitted | ✓ (check) | Success (jika lewat) |
| Signed/Assigned | ✓ (check) | Success (jika lewat) |
| In Progress | ✓ (check) | Success (jika lewat) |
| Resolved | ✓ (check) | Success (jika lewat) |
| Closed | ✓ (check) atau ○ (kosong) | Success / Border |

**Visual:**
- Filled icon + connecting line = Completed
- Filled icon + no line = Current
- Empty icon = Pending

### 4. Ticket Details Section

| Field | Value | Editable |
|-------|-------|----------|
| Pembuat | User name + role | No |
| Email | User email | No |
| Prioritas | High/Medium/Low | **No** (read-only) |
| Ditugaskan | Helpdesk name (jika assigned) | **Yes** (jika status Submitted) |
| Tanggal Dibuat | DateTime | No |
| Terakhir Update | DateTime | No |

**Catatan**: Admin **tidak bisa** mengubah prioritas tiket (di-handle oleh sistem/saat User buat).

### 5. Description Section
- Expandable text
- Full description text
- Copy button

### 6. Attachments Section
- File icon based on file type
- File name + size
- Download button

### 7. Conversation Section

Chat-style interface. Sender bisa:
- **User** (Pembuat tiket)
- **Helpdesk** (yang di-assign)
- **Admin** (Admin bisa ikut komentar, tapi tidak wajib)

### 8. Quick Actions Bar (Kontekstual Sesuai Status)

#### 8a. Tombol "Assign ke Helpdesk" (status = Submitted)

```
┌─────────────────────────────────────┐
│ Tugaskan ke Helpdesk                │
├─────────────────────────────────────┤
│ 🔍 Cari helpdesk...                 │
├─────────────────────────────────────┤
│ ○ Sarah (Helpdesk) - Available      │
│   📊 5 tiket aktif                  │
│ ○ John (Helpdesk) - Available       │
│   📊 3 tiket aktif                  │
│ ○ Budi (Helpdesk) - On Leave        │
│   📊 0 tiket aktif                  │
├─────────────────────────────────────┤
│        [Batal]  [Tugaskan]          │
└─────────────────────────────────────┘
```

**Behavior:**
- Menampilkan Helpdesk yang statusnya `available`
- Menampilkan jumlah tiket aktif per Helpdesk (info beban kerja)
- Tap Helpdesk → Konfirmasi → Status berubah ke `Signed/Assigned`
- Notifikasi dikirim ke Helpdesk yang di-assign

#### 8b. Tombol "Batalkan Assignment" (status = Signed/Assigned)

```
┌─────────────────────────────────────┐
│ ⚠️  Batalkan Assignment?            │
├─────────────────────────────────────┤
│ Tiket akan dikembalikan ke status   │
│ Submitted. Tiket Helpdesk saat ini  │
│ tidak akan lagi melihat tiket ini.  │
│                                     │
│ Alasan pembatalan:                  │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│   [Batal]  [Batalkan Assignment]   │
└─────────────────────────────────────┘
```

**Behavior:**
- Status kembali ke `Submitted`
- Helpdesk yang di-assign menerima notifikasi pembatalan
- Wajib mengisi alasan pembatalan

#### 8c. Tombol "Close Tiket" (status = Resolved)

```
┌─────────────────────────────────────┐
│ ✅  Close Tiket                      │
├─────────────────────────────────────┤
│ Checklist Quality Control:          │
│ ☑ User sudah konfirmasi selesai     │
│ ☑ Helpdesk sudah upload bukti       │
│ ☑ Hasil kerja sesuai dengan laporan │
│                                     │
│ Catatan penutupan (opsional):        │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│   [Batal]  [Close Tiket]           │
└─────────────────────────────────────┘
```

**Behavior:**
- Wajib semua checklist tercentang (kecuali catatan opsional)
- Status berubah ke `Closed` (final)
- Notifikasi dikirim ke User dan Helpdesk
- Tiket masuk ke Riwayat Tiket

### 9. Message Input

| Element | Description |
|---------|-------------|
| Attach Button | Add attachment to message |
| Text Field | Multi-line input |
| Send Button | Send message |
| Character Count | X/500 |

**Validation:**
- Empty message: disabled send
- Max 500 characters

## States

### Loading State
- Skeleton for all sections
- Disabled action buttons

### Error State
- "Gagal memuat detail tiket"
- Retry button

### Empty States
- No description: "Tidak ada deskripsi"
- No attachment: "Tidak ada lampiran"
- No conversation: "Belum ada percakapan"

## Business Rules

1. **QC Wajib**: Sebelum close tiket, Admin WAJIB memastikan User sudah konfirmasi (tombol "Konfirmasi Selesai" di sisi User).
2. **Tidak bisa loncat status**: Admin hanya bisa assign (Submitted → Signed) atau close (Resolved → Closed). Tidak bisa langsung Submitted → In Progress.
3. **Batalkan assignment hanya jika status Signed/Assigned**: Jika sudah In Progress, Admin harus menunggu Helpdesk menyelesaikan atau restart tiket.
4. **Closed adalah final**: Tidak ada transisi dari Closed.

## Technical Requirements

### Navigation
- `/admin/ticket/:id` - Ticket detail

### Data Model
```dart
class AdminTicketDetail {
  String id;
  String ticketId;
  String title;
  String description;
  String category;
  String status;
  String priority;
  String? assignedToId;
  String? assignedToName;
  String createdById;
  String createdByName;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? assignedAt;
  DateTime? resolvedAt;
  DateTime? closedAt;
  List<Attachment> attachments;
  List<Comment> comments;
  bool userConfirmation;  // Penting untuk close
}
```

### API Endpoints (Mock)
- `GET /admin/tickets/:id` - Get ticket detail
- `POST /admin/tickets/:id/assign` - Assign to helpdesk
- `POST /admin/tickets/:id/cancel-assignment` - Cancel assignment
- `POST /admin/tickets/:id/close` - Close ticket (with QC checklist)
- `POST /admin/tickets/:id/comments` - Add comment

## Dependencies

### Required Pages
- AdminTicketDetailPage
- AssignHelpdeskModal
- CloseTicketModal

### Required Widgets
- StatusBadge
- PriorityBadge
- CategoryBadge
- ConversationList
- CommentInput
- QCChecklist

### Required Services
- TicketService
- HelpdeskService
- CommentService
