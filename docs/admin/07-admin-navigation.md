# Admin Navigation

## Overview

Komponen navigasi khusus untuk role **Admin** yang mencakup bottom navigation bar dan header navigation.

> **Catatan**: Halaman ini khusus untuk navigasi Admin. Untuk navigasi Helpdesk, lihat [../helpdesk/06-helpdesk-navigation.md](../helpdesk/06-helpdesk-navigation.md).

## Bottom Navigation Bar

### Visual Design

```
┌─────────────────────────────────────┐
│                                      │
│  [🏠]     [📋]     [🔔]     [👤]   │
│   Beranda  Tiket   Notifikasi Profil│
│                                      │
└─────────────────────────────────────┘
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| currentIndex | int | 0 | Currently selected tab |
| onTap | Function | - | Callback when tab is tapped |
| badgeCount | Map | {} | Badge counts per tab |

### Tab Configuration

| Index | Label | Icon (default) | Icon (active) | Route |
|-------|-------|----------------|---------------|-------|
| 0 | Beranda | `home_outlined` | `home` | `/admin` |
| 1 | Tiket | `description_outlined` | `description` | `/admin/tickets` |
| 2 | Notifikasi | `notifications_outlined` | `notifications` | `/admin/notifications` |
| 3 | Profil | `person_outline` | `person` | `/admin/profile` |

### Badge Display

| Condition | Badge |
|-----------|-------|
| badgeCount > 0 | Red circle with count |
| badgeCount > 9 | Red circle with "9+" |
| badgeCount == 0 | No badge |

### Color Scheme

| State | Color |
|-------|-------|
| Active | Primary (#4F46E5) |
| Inactive | Gray (#6B7280) |
| Badge | Error (#EF4444) |
| Background | Surface (#FFFFFF) |
| Shadow | Black 10% opacity |

## Header Navigation

### Admin Header

```
┌─────────────────────────────────────┐
│ [←] [Title           ] [🔍] [👤]  │
└─────────────────────────────────────┘
```

### Components

| Component | Description |
|-----------|-------------|
| Back Button | Arrow icon, navigates back |
| Title | Page title, centered or left-aligned |
| Search Button | Opens search (optional) |
| Profile Avatar | User avatar, navigates to profile |

### Header Variations

**Standard Header:**
```
┌─────────────────────────────────────┐
│ [←] Page Title           [🔍] [👤]│
└─────────────────────────────────────┘
```

**Search Header:**
```
┌─────────────────────────────────────┐
│ [←] [🔍 Search here...      ] [✕] │
└─────────────────────────────────────┘
```

**Actions Header:**
```
┌─────────────────────────────────────┐
│ [←] Page Title     [🔍] [⚙️] [👤] │
└─────────────────────────────────────┘
```

## Drawer Navigation (Optional)

For admin with extended permissions:

```
┌─────────────────────────────────────┐
│ 👤 Sarah Admin                       │
│    sarah@university.ac              │
│    Administrator                    │
├─────────────────────────────────────┤
│ 🏠 Dashboard                        │
│ 📋 Daftar Tiket                     │
│ 👥 Manajemen User                   │
│ 📊 Laporan & Statistik               │
│ 🏷️ Kelola Kategori                  │
│ ⚙️ Pengaturan                        │
├─────────────────────────────────────┤
│ 🚪 Keluar                           │
└─────────────────────────────────────┘
```

## Code Implementation

### Bottom Nav Bar Widget

```dart
class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<int, int> badgeCounts;

  const AdminBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Beranda',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description,
              label: 'Tiket',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Notifikasi',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
              badgeCount: badgeCounts[2] ?? 0,
            ),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profil',
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
```

## State Management

### Navigation State

```dart
class AdminNavigationState {
  int currentIndex = 0;
  bool isSearchActive = false;
  String searchQuery = '';

  void setIndex(int index);
  void toggleSearch();
  void setSearchQuery(String query);
  void clearSearch();
}
```

## Dependencies

### Required Imports
- app_colors.dart
- app_constants.dart

### Required Widgets
- _NavItem (private)
- BadgeDisplay