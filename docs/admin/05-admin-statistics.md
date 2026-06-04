# Admin Statistics & Reports

## Overview

Halaman Statistik untuk **Admin** yang menampilkan laporan dan visualisasi data tiket **global** (semua tiket dari semua user) berdasarkan periode tertentu. Fitur ini membantu admin dalam monitoring performa dan membuat keputusan berdasarkan data.

> **Catatan**: Halaman ini menampilkan statistik **global**. Untuk statistik personal Helpdesk, lihat [../helpdesk/04-helpdesk-statistics.md](../helpdesk/04-helpdesk-statistics.md).

## Visual Design

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#4F46E5` | Charts, highlights |
| Background | `#F3F4F6` | Page background |
| Surface | `#FFFFFF` | Cards, containers |
| Text Primary | `#111827` | Headings |
| Text Secondary | `#6B7280` | Labels |
| Success | `#10B981` | Positive data |
| Warning | `#F59E0B` | Neutral data |
| Error | `#EF4444` | Negative data |

### Typography

| Element | Font | Size | Weight |
|---------|------|------|--------|
| Page Title | Inter | 24px | 700 |
| Chart Title | Inter | 16px | 600 |
| Stat Number | Inter | 32px | 700 |
| Stat Label | Inter | 14px | 400 |
| Caption | Inter | 12px | 400 |

## Layout Structure

```
┌─────────────────────────────────────┐
│ Header                              │
│ [←] Laporan & Statistik   [📅] [📤] │
├─────────────────────────────────────┤
│ Date Range Filter                   │
│ [📅 1 Mar 2024 - 31 Mar 2024 ▼]    │
│ [Minggu Ini] [Bulan Ini] [Custom]   │
├─────────────────────────────────────┤
│ Overview Stats                       │
│ ┌─────────────────────────────────┐ │
│ │ Total    │ Selesai  │ Avg Time  │ │
│ │   150    │   120    │   2.5 jam │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Ticket Status Distribution           │
│ ┌─────────────────────────────────┐ │
│ │     [📊 Bar Chart]              │ │
│ │     ████░░░░░░░░░░             │ │
│ │     ██████████████░░           │ │
│ │     ████████████░░░░           │ │
│ │     █████████░░░░░░░           │ │
│ │     ─────────────────────     │ │
│ │     baru  ditangan  proses      │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Category Distribution                │
│ ┌─────────────────────────────────┐ │
│ │ Akademik      ███████████ 45   │ │
│ │ Teknologi      ████████░░░ 32  │ │
│ │ Fasilitas      █████░░░░░░░ 20  │ │
│ │ Keuangan       ███░░░░░░░░░ 15  │ │
│ │ Lainnya        ██░░░░░░░░░░ 8   │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Priority Distribution                │
│ ┌─────────────────────────────────┐ │
│ │ [Tinggi] ████████░░░░ 25       │ │
│ │ [Sedang] █████████████ 45       │ │
│ │ [Rendah] ██████░░░░░░░ 20       │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Staff Performance                    │
│ ┌─────────────────────────────────┐ │
│ │ Sarah   │███████│ 85% │ 45 tik  │ │
│ │ Budi    │██████ │ 75% │ 38 tik  │ │
│ │ John    │█████  │ 65% │ 32 tik  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Trend Chart                          │
│ ┌─────────────────────────────────┐ │
│ │ [📈 Line Chart]                 │ │
│ │     ╱╲                          │ │
│ │    ╱  ╲    ╱╲                   │ │
│ │   ╱    ╲__╱  ╲___              │ │
│ │ ────────────────────────       │ │
│ │ M   S   S   S   S   M         │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Admin Bottom Navigation              │
└─────────────────────────────────────┘
```

## Features & Interactions

### 1. Date Range Filter

**Quick Filters:**
| Option | Description |
|--------|-------------|
| Hari Ini | Today's data |
| Minggu Ini | Current week (Mon-Sun) |
| Bulan Ini | Current month |
| Custom | User selects date range |

**Custom Date Picker:**
- Start date picker
- End date picker
- Max range: 90 days
- Validation: End >= Start

### 2. Export Options

| Format | Icon | Description |
|--------|------|-------------|
| PDF | `picture_as_pdf` | Generate PDF report |
| Excel | `table_chart` | Export to Excel |

### 3. Overview Stats Cards

| Stat | Calculation | Icon |
|------|-------------|------|
| Total Tiket | Count all tickets | `description` |
| Selesai | Count completed | `check_circle` |
| Dalam Proses | Count in-progress | `pending` |
| Avg Response Time | Average duration | `schedule` |

**Card Design:**
- Large number display
- Label below
- Icon with colored background
- Tap to see detailed breakdown

### 4. Status Distribution Chart

**Bar Chart showing:**
- X-axis: Status categories
- Y-axis: Ticket count

**Status Colors:**
| Status | Bar Color |
|--------|-----------|
| Baru | Warning (#F59E0B) |
| Ditangani | Info (#3B82F6) |
| Diproses | Primary (#4F46E5) |
| Selesai | Success (#10B981) |
| Ditolak | Error (#EF4444) |

**Interaction:**
- Tap bar → Show tooltip with exact count
- Long press → Show percentage

### 5. Category Distribution

**Horizontal Bar Chart:**

| Category | Bar Color |
|----------|-----------|
| Akademik | Amber (#F59E0B) |
| Teknologi | Blue (#3B82F6) |
| Fasilitas | Pink (#EC4899) |
| Keuangan | Green (#10B981) |
| Lainnya | Gray (#6B7280) |

**Display:**
- Category name
- Bar with percentage fill
- Count number

### 6. Priority Distribution

**Segmented Progress Bar:**

| Priority | Color | Percentage |
|----------|-------|------------|
| Tinggi | Error (#EF4444) | X% |
| Sedang | Warning (#F59E0B) | X% |
| Rendah | Success (#10B981) | X% |

### 7. Helpdesk Performance

**Performance Table (Semua Helpdesk):**

| Column | Description |
|--------|-------------|
| Helpdesk Name | Nama Helpdesk |
| Progress Bar | Visual completion rate |
| Completion % | Percentage completed on time |
| Ticket Count | Total tickets assigned |
| Avg Time | Average resolution time |

**Sorting:**
- By name (A-Z)
- By completion rate (High-Low)
- By ticket count (High-Low)

### 8. Trend Chart

**Line Chart showing:**
- Daily ticket creation trend
- X-axis: Date
- Y-axis: Ticket count
- Multiple lines: Created vs Resolved

**Interaction:**
- Tap point → Show tooltip
- Pinch zoom → Adjust time range

### 9. Real-time Updates

- Pull to refresh data
- Auto-refresh every 5 minutes
- Show "Last updated: X minutes ago"

## States

### Loading State
- Skeleton charts
- Shimmer effect on numbers

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│        📊                          │
│                                     │
│    Tidak ada data                   │
│    untuk periode ini                │
│                                     │
│    [Ubah Tanggal]                   │
│                                     │
└─────────────────────────────────────┘
```

### Error State
- "Gagal memuat statistik"
- Retry button

## Technical Requirements

### Navigation
- `/admin/statistics` - Statistics page

### Query Parameters
```
/admin/statistics?start=2024-03-01&end=2024-03-31
```

### Data Model
```dart
class StatisticsData {
  DateTime startDate;
  DateTime endDate;
  OverviewStats overview;
  List<StatusCount> statusDistribution;
  List<CategoryCount> categoryDistribution;
  List<PriorityCount> priorityDistribution;
  List<StaffPerformance> staffPerformance;
  List<TrendPoint> trendData;
}

class OverviewStats {
  int totalTickets;
  int completedTickets;
  int inProgressTickets;
  double avgResponseTimeHours;
  double resolutionRate; // percentage
}

class StatusCount {
  String status;
  int count;
  double percentage;
}

class CategoryCount {
  String category;
  int count;
  double percentage;
}

class PriorityCount {
  String priority;
  int count;
  double percentage;
}

class HelpdeskPerformance {
  String helpdeskId;
  String helpdeskName;
  int totalAssigned;
  int completed;
  double completionRate;
  double avgResolutionHours;
}

class TrendPoint {
  DateTime date;
  int created;
  int resolved;
}
```

### API Endpoints (Mock)
- `GET /statistics/overview` - Get overview stats
- `GET /statistics/distribution` - Get distribution data
- `GET /statistics/staff` - Get staff performance
- `GET /statistics/trend` - Get trend data
- `POST /statistics/export` - Generate export file

### Chart Libraries
- fl_chart (for bar charts, line charts)
- Or custom implementation with Canvas

## Dependencies

### Required Pages
- StatisticsPage

### Required Widgets
- StatCard
- BarChart
- LineChart
- ProgressBar
- DateRangePicker
- ExportButton
- StaffPerformanceTable
- TrendChart