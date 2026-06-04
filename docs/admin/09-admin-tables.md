# Admin Data Tables

## Overview

Komponen tabel yang digunakan di halaman **Admin** untuk menampilkan data dalam format grid, seperti daftar user, statistik helpdesk, dan data laporan.

> **Catatan**: Halaman ini khusus untuk tabel Admin. Untuk tabel Helpdesk, lihat [../helpdesk/08-helpdesk-tables.md](../helpdesk/08-helpdesk-tables.md).

## Data Table Widget

### Visual Design

```
┌─────────────────────────────────────┐
│ Header Row                          │
├─────────────────────────────────────┤
│ Column 1  │ Column 2  │ Column 3     │
├──────────┼──────────┼──────────────┤
│ Data 1   │ Data 2   │ Data 3       │
├──────────┼──────────┼──────────────┤
│ Data 4   │ Data 5   │ Data 6       │
├──────────┼──────────┼──────────────┤
│ Data 7   │ Data 8   │ Data 9       │
└──────────┴──────────┴──────────────┘
```

### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| headers | List<String> | Yes | Column titles |
| rows | List<List<Widget>> | Yes | Table data |
| sortable | bool | No | Enable column sorting |
| onSort | Function | No | Sort callback |
| emptyText | String | No | Empty state text |

### Color Scheme

| Element | Color |
|---------|-------|
| Header Background | Surface (#FFFFFF) |
| Header Text | Text Primary (#111827) |
| Row Background (odd) | Background (#F3F4F6) |
| Row Background (even) | Surface (#FFFFFF) |
| Divider | Border (#E5E7EB) |
| Row Hover | Primary Light (#EEF2FF) |

### Features

#### Sorting
- Tap header to sort ascending
- Tap again for descending
- Show sort indicator (↑/↓)

#### Row Actions
- Tap row → Navigate to detail
- Long press → Show action menu
- Swipe left → Quick action

#### Pagination
- Items per page: 10, 20, 50
- Page navigation controls
- Total count display

## Helpdesk Performance Table

### Visual Design

```
┌─────────────────────────────────────┐
│ Performa Helpdesk                   │
├─────────────────────────────────────┤
│ Nama       │ Selesai │ Waktu │ Rate │
├────────────┼─────────┼───────┼──────┤
│ Sarah (H)  │ 45      │ 2.1j  │ 92% ██ │
│ Budi (H)   │ 38      │ 2.8j  │ 85% █▓ │
│ John (H)   │ 32      │ 3.2j  │ 78% █░ │
└────────────┴─────────┴───────┴──────┘
```

### Columns

| Column | Width | Content |
|--------|-------|---------|
| Nama | 30% | Helpdesk name with avatar |
| Selesai | 15% | Completed ticket count |
| Waktu | 15% | Avg resolution time |
| Rate | 40% | Completion rate + progress bar |

### Progress Bar

```dart
// Rate progress bar colors
const rateColors = {
  'high': Color(0xFF10B981),   // >= 80% Green
  'medium': Color(0xFFF59E0B), // 50-79% Yellow
  'low': Color(0xFFEF4444),    // < 50% Red
};
```

## Ticket Statistics Table

### Visual Design

```
┌─────────────────────────────────────┐
│ Statistik Tiket per Periode         │
├─────────────────────────────────────┤
│ Periode  │ Total │ Selesai │ %     │
├──────────┼───────┼─────────┼───────┤
│ Minggu 1 │ 45    │ 42      │ 93%   │
│ Minggu 2 │ 52    │ 48      │ 92%   │
│ Minggu 3 │ 38    │ 35      │ 92%   │
│ Minggu 4 │ 41    │ 39      │ 95%   │
└──────────┴───────┴─────────┴───────┘
```

## User List Table

### Visual Design

```
┌─────────────────────────────────────┐
│ 👤 Users                    [Filter]│
├─────────────────────────────────────┤
│ ☐ │ Nama       │ Role    │ Status  │
├───┼────────────┼─────────┼─────────┤
│ ☐ │ John Doe   │ User    │ Aktif  │
│ ☐ │ Sarah H.   │ Helpdesk│ Aktif  │
│ ☑ │ Ahmad A.   │ Admin   │ Aktif  │
└───┴────────────┴─────────┴─────────┘
│ [Select All] [Assign] [Delete]      │
└─────────────────────────────────────┘
```

### Selection Mode

When user enters selection mode:
- Checkbox appears on each row
- Header checkbox for select all
- Action bar appears at bottom

### Row Design

```
┌─────────────────────────────────────┐
│ [☐] 👤 John Doe           [⋮]     │
│     NIM: 12345678                   │
│     Aktif • Mahasiswa              │
└─────────────────────────────────────┘
```

## Code Implementation

### DataTable Widget

```dart
class AdminDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final bool sortable;
  final Function(int, bool)? onSort;
  final Function(int)? onRowTap;
  final bool selectable;
  final Set<int>? selectedRows;

  const AdminDataTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.sortable = false,
    this.onSort,
    this.onRowTap,
    this.selectable = false,
    this.selectedRows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          // Rows
          ...rows.asMap().entries.map((entry) =>
            _buildRow(entry.key, entry.value)
          ),
        ],
      ),
    );
  }
}
```

## States

### Loading State
- Skeleton rows (5 placeholder rows)
- Shimmer effect

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│        📋                          │
│                                     │
│    Tidak ada data                   │
│    yang tersedia                    │
│                                     │
└─────────────────────────────────────┘
```

### Error State
- Error message
- Retry button

## Responsive Behavior

| Screen Width | Columns | Actions |
|-------------|---------|---------|
| < 360px | 2 columns | Tap to expand |
| 360-480px | 3 columns | Visible |
| > 480px | All columns | Visible |

## Dependencies

### Required Imports
- app_colors.dart
- app_constants.dart

### Required Widgets
- SortableHeader
- TableRow
- ProgressBarCell
- CheckboxCell
- ActionMenuButton