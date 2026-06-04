# Admin Feature Documentation

## Overview

Dokumentasi ini berisi spesifikasi fitur untuk role **Admin** (Pengelola Sistem) dalam aplikasi E-Ticketing Helpdesk. Admin bertanggung jawab menerima tiket dari User, mendistribusikan tiket ke Helpdesk, melakukan Quality Control (QC), dan menutup tiket setelah User mengkonfirmasi penyelesaian.

> **Catatan Revisi**: Dokumentasi awal (SRS v1.0.0) menggabungkan role **Admin** dan **Helpdesk** sebagai satu role gabungan. Setelah revisi, role **Admin** dan **Helpdesk** dipisahkan menjadi 2 role yang berbeda. Untuk dokumentasi Helpdesk, lihat folder `../helpdesk/`.

## Features

| # | Feature | Description |
|---|---------|-------------|
| 1 | [Admin Dashboard](01-admin-dashboard.md) | Halaman utama untuk overview statistik global dan monitoring sistem |
| 2 | [Admin Ticket List](02-admin-ticket-list.md) | Daftar semua tiket dari semua user dengan filter, pencarian, dan bulk actions |
| 3 | [Admin Ticket Detail](03-admin-ticket-detail.md) | Detail tiket dengan fitur assign ke Helpdesk dan close tiket |
| 4 | [Admin User Management](04-admin-user-management.md) | Manajemen data pengguna (user, admin, helpdesk) |
| 5 | [Admin Statistics](05-admin-statistics.md) | Laporan dan statistik global tiket |
| 6 | [Admin Settings](06-admin-settings.md) | Pengaturan akun dan aplikasi |

## Tanggung Jawab Admin

| Tanggung Jawab | Keterangan |
|----------------|------------|
| Menerima tiket masuk | Melihat tiket `Submitted` dari semua user |
| Assign tiket ke Helpdesk | Menugaskan tiket ke Helpdesk tertentu (status `Signed/Assigned`) |
| Monitoring keseluruhan | Memantau perkembangan tiket yang di-assign ke Helpdesk |
| Quality Control (QC) | Memverifikasi hasil kerja Helpdesk sebelum close |
| Close tiket | Menutup tiket setelah User konfirmasi (status `Closed`) |
| User management | Mengelola data pengguna (User & Helpdesk) |
| Statistik global | Melihat statistik komprehensif semua tiket |

## Navigation Structure

```
Admin Bottom Navigation:
├── Dashboard (Beranda) — Statistik global
├── Tiket (Daftar Tiket) — Semua tiket dari semua user
├── Notifikasi
└── Profil

Admin Top Navigation:
├── Search
├── Filter
└── Settings
```

## Hak Akses Admin

| Fitur | Akses |
|-------|-------|
| Login/Logout/Reset Password | ✅ |
| Lihat semua tiket | ✅ |
| Assign tiket ke Helpdesk | ✅ |
| Tutup tiket (setelah User konfirmasi) | ✅ |
| Update status `Submitted` → `Signed/Assigned` | ✅ |
| Update status `Resolved` → `Closed` | ✅ |
| User management | ✅ |
| Statistik global | ✅ |
| Update status ke `In Progress` (kerjakan tiket) | ❌ (Tugas Helpdesk) |
| Update status ke `Resolved` (selesaikan tiket) | ❌ (Tugas Helpdesk) |

## Common UI Components

- [Admin Navigation Bar](07-admin-navigation.md)
- [Admin Status Badges](08-admin-badges.md)
- [Admin Data Tables](09-admin-tables.md)
- [Admin Forms](10-admin-forms.md)

## File Terkait

- [../workflow/00-overview.md](../workflow/00-overview.md) - Overview alur 3 role
- [../workflow/02-admin-flow.md](../workflow/02-admin-flow.md) - Detail alur Admin
- [../workflow/04-status-mapping.md](../workflow/04-status-mapping.md) - Mapping status vs role
- [../workflow/05-screen-mapping.md](../workflow/05-screen-mapping.md) - Pemetaan layar per role
- [../helpdesk/README.md](../helpdesk/README.md) - Dokumentasi Helpdesk
