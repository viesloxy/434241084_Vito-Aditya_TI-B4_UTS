# Dokumentasi Frontend - E-Ticketing Helpdesk Mobile App

## Deskripsi Proyek
Aplikasi mobile E-Ticketing Helpdesk untuk universitas yang memungkinkan mahasiswa dan staff untuk membuat, melacak, dan mengelola tiket bantuan.

> **Catatan**: Dokumentasi ini mencakup **Frontend** dan **Backend** (Node.js/Express + Supabase). Lihat folder `api/` di docs untuk dokumentasi API lengkap.

---

## Daftar Fitur

| No | Fitur | File Dokumentasi |
|----|-------|------------------|
| 01 | Login | [01-login.md](features/01-login.md) |
| 02 | Register | [02-register.md](features/02-register.md) |
| 03 | Home / Dashboard | [03-home.md](features/03-home.md) |
| 04 | Create Ticket | [04-create-ticket.md](features/04-create-ticket.md) |
| 05 | Ticket History | [05-ticket-history.md](features/05-ticket-history.md) |
| 06 | Ticket Detail | [06-ticket-detail.md](features/06-ticket-detail.md) |
| 07 | Notifications | [07-notifications.md](features/07-notifications.md) |
| 08 | Profile | [08-profile.md](features/08-profile.md) |
| 09 | Komponen Global | [09-global-components.md](features/09-global-components.md) |
| 10 | Forgot Password | [10-forgot-password.md](features/10-forgot-password.md) |

---

## Struktur Dokumentasi

```
docs/
├── README.md                    # Dokumentasi utama
└── features/
    ├── 01-login.md             # Fitur Login
    ├── 02-register.md          # Fitur Register
    ├── 03-home.md              # Fitur Home/Dashboard
    ├── 04-create-ticket.md     # Fitur Buat Tiket
    ├── 05-ticket-history.md    # Fitur Riwayat Tiket
    ├── 06-ticket-detail.md     # Fitur Detail Tiket
    ├── 07-notifications.md     # Fitur Notifikasi
    ├── 08-profile.md           # Fitur Profil
    ├── 09-global-components.md # Komponen UI Global
    └── 10-forgot-password.md  # Fitur Lupa Password (FR-004)
```

---

## Design System

### Font
- **Primary Font**: Inter (Google Fonts)
- **Fallback**: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif
- **Weights**: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)

### Color Palette

#### Primary Colors
| Name | Hex | Usage |
|------|-----|-------|
| Primary | #2563EB | Main actions, links |
| Primary Hover | #1D4ED8 | Hover states |
| Primary Light | #EFF6FF | Light backgrounds |

#### Neutral Colors
| Name | Hex | Usage |
|------|-----|-------|
| Background | #F9FAFB | Page background |
| Surface | #FFFFFF | Cards, modals |
| Text Primary | #1F2937 | Main text |
| Text Secondary | #6B7280 | Secondary text |
| Border | #E5E7EB | Borders, dividers |

#### Semantic Colors
| Name | Hex | Usage |
|------|-----|-------|
| Success | #10B981 | Success states |
| Warning | #F59E0B | Warning states |
| Error | #EF4444 | Error states |

### Spacing (8pt Grid)
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 20px
- 2xl: 24px
- 3xl: 32px

### Border Radius
- Small: 8px
- Medium: 12px
- Large: 16px
- Pill: 9999px

### Shadows
```css
/* Card Shadow */
box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);

/* Elevated Shadow */
box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);

/* Bottom Nav Shadow */
box-shadow: 0 -1px 3px 0 rgba(0, 0, 0, 0.1);
```

---

## Kategori Tiket

| Kategori | Ikon | Warna |
|----------|------|-------|
| Akademik | book-outline | #FEF3C7 / #92400E |
| Teknologi | laptop-outline | #DBEAFE / #1E40AF |
| Fasilitas | business-outline | #FCE7F3 / #9D174D |
| Keuangan | card-outline | #D1FAE5 / #065F46 |
| Lainnya | ellipsis-horizontal-outline | #E5E7EB / #374151 |

## Status Tiket

| Status | Ikon | Warna |
|--------|------|-------|
| Baru | time-outline | #FEF3C7 / #92400E |
| Ditangani | checkmark-outline | #DBEAFE / #1E40AF |
| Diproses | refresh-outline | #E0E7FF / #3730A3 |
| Selesai | checkmark-circle-outline | #D1FAE5 / #065F46 |
| Dibatalkan | close-outline | #FEE2E2 / #991B1B |

## Prioritas Tiket

| Prioritas | Warna |
|-----------|-------|
| Rendah | #D1FAE5 / #065F46 |
| Sedang | #FEF3C7 / #92400E |
| Tinggi | #FEE2E2 / #991B1B |

---

## User Roles

| Role | Deskripsi |
|------|-----------|
| Mahasiswa | Mahasiswa universitas |
| Staff | Staff/Dosen universitas |

---

## Tech Stack yang Direkomendasikan

### Framework & Library
- **Framework**: Flutter atau React Native
- **State Management**: Provider/Bloc (Flutter) atau Zustand/Context API (React Native)
- **Navigation**: React Navigation / Go Router
- **UI Components**: Material Design 3 atau Custom Components

### Styling
- CSS-in-JS atau Styled Components
- Tailwind CSS
- Design Tokens untuk konsistensi

### Icons
- Ionicons (direkomendasikan)
- Material Icons
- Feather Icons

### Font
- Inter (Google Fonts)

---

## Mock Data Structure

### User
```json
{
  "id": "user-001",
  "name": "Nama Lengkap",
  "email": "email@university.ac.id",
  "role": "mahasiswa",
  "nim": "12345678",
  "jurusan": "Informatika",
  "avatar": "https://...",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Ticket
```json
{
  "id": "TK-2024-001",
  "title": "Judul Tiket",
  "description": "Deskripsi masalah...",
  "category": "akademik",
  "priority": "sedang",
  "status": "baru",
  "userId": "user-001",
  "assignedTo": "staff-001",
  "attachments": ["url1", "url2"],
  "comments": [],
  "createdAt": "2024-01-21T10:00:00Z",
  "updatedAt": "2024-01-21T10:00:00Z"
}
```

### Notification
```json
{
  "id": "notif-001",
  "userId": "user-001",
  "ticketId": "TK-2024-001",
  "type": "status_update",
  "title": "Status Tiket Diperbarui",
  "message": "Tiket #TK-2024-001 sedang diproses",
  "isRead": false,
  "createdAt": "2024-01-21T10:30:00Z"
}
```

---

## Catatan Penting

1. **Frontend Only**: Dokumentasi ini hanya mencakup aspek frontend. Backend diabaikan.
2. **Mobile-First**: Desain menggunakan pendekatan mobile-first.
3. **Touch-Friendly**: Semua touch targets minimum 44x44px.
4. **Responsive**: Mendukung berbagai ukuran layar mobile (360px - 428px).
5. **Accessible**: Mempertimbangkan aksesibilitas dalam desain.

---

## Langkah Selanjutnya

1. [ ] Setup project dengan framework pilihan
2. [ ] Konfigurasi design tokens
3. [ ] Implement komponen global
4. [ ] Implement halaman per halaman sesuai dokumentasi
5. [ ] Testing dan refinement

---

*Dokumentasi dibuat berdasarkan Software Requirement Specification (SRS)*
