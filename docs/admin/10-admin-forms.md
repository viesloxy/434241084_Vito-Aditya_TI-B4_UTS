# Admin Forms

## Overview

Koleksi komponen form yang digunakan di halaman **Admin** untuk input data, termasuk text field, dropdown, date picker, dan form actions.

> **Catatan**: Halaman ini khusus untuk form Admin. Untuk form Helpdesk, lihat [../helpdesk/09-helpdesk-forms.md](../helpdesk/09-helpdesk-forms.md).

## Text Input Fields

### Standard Text Field

```
┌─────────────────────────────────────┐
│ Label                               │
│ ┌─────────────────────────────────┐ │
│ │ Placeholder text...             │ │
│ └─────────────────────────────────┘ │
│ Helper text                         │
└─────────────────────────────────────┘
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| labelText | String | Field label |
| hintText | String | Placeholder |
| helperText | String | Help text below |
| errorText | String | Error message |
| prefixIcon | IconData | Leading icon |
| suffixIcon | IconData | Trailing icon |
| obscureText | bool | Password field |
| maxLines | int | Multi-line input |
| keyboardType | TextInputType | Keyboard type |
| validator | Function | Validation function |

### States

| State | Border Color | Background |
|-------|-------------|------------|
| Default | Border (#E5E7EB) | Surface (#FFFFFF) |
| Focused | Primary (#4F46E5) | Surface (#FFFFFF) |
| Error | Error (#EF4444) | Error Light (#FEF2F2) |
| Disabled | Border (#E5E7EB) | Gray (#F9FAFB) |

### Validation

```dart
String? validateRequired(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field ini wajib diisi';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email wajib diisi';
  }
  if (!GetUtils.isEmail(value)) {
    return 'Format email tidak valid';
  }
  return null;
}

String? validateMinLength(String? value, int min) {
  if (value == null || value.isEmpty) {
    return 'Field ini wajib diisi';
  }
  if (value.length < min) {
    return 'Minimal $min karakter';
  }
  return null;
}
```

## Dropdown / Select

### Visual Design

```
┌─────────────────────────────────────┐
│ Label                               │
│ ┌─────────────────────────────────┐ │
│ │ Select option            ▼     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Dropdown Modal

```
┌─────────────────────────────────────┐
│ Select Label                        │
├─────────────────────────────────────┤
│ 🔍 Search...                        │
├─────────────────────────────────────┤
│ ○ Option 1                          │
│ ● Option 2 (selected)              │
│ ○ Option 3                          │
│ ○ Option 4                          │
└─────────────────────────────────────┘
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| labelText | String | Field label |
| value | dynamic | Selected value |
| items | List | Dropdown options |
| onChanged | Function | Selection callback |
| validator | Function | Validation function |
| searchable | bool | Enable search |

## Date Picker

### Visual Design

```
┌─────────────────────────────────────┐
│ Label                               │
│ ┌─────────────────────────────────┐ │
│ │ 📅 Select date           ▼     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Date Picker Modal

```
┌─────────────────────────────────────┐
│        April 2024                   │
│  <     [H] [B] [S] [K] [J] [S]     │
│ M   1  2  3  4  5  6  7            │
│ S   8  9 10 11 12 13 14            │
│ S  15 16 17 18 19 20 21            │
│ R  22 23 24 25 26 27 28            │
│ K  29 30                            │
├─────────────────────────────────────┤
│        [Batal]  [Pilih]             │
└─────────────────────────────────────┘
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| labelText | String | Field label |
| value | DateTime | Selected date |
| firstDate | DateTime | Min selectable date |
| lastDate | DateTime | Max selectable date |
| onChanged | Function | Selection callback |

## Date Range Picker

### Visual Design

```
┌─────────────────────────────────────┐
│ [📅 01 Mar 2024 - 31 Mar 2024]    │
└─────────────────────────────────────┘
```

### Quick Options

| Option | Description |
|--------|-------------|
| Hari Ini | Today only |
| 7 Hari Terakhir | Last 7 days |
| Bulan Ini | Current month |
| Custom | User selects range |

## Toggle Switch

### Visual Design

```
┌─────────────────────────────────────┐
│ Label                        [OFF] │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ Label                         [ON] │
└─────────────────────────────────────┘
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| value | bool | Current state |
| onChanged | Function | Toggle callback |
| label | String | Switch label |
| description | String | Helper text |

### Colors

| State | Track Color | Thumb Color |
|-------|-------------|-------------|
| OFF | Gray (#E5E7EB) | White (#FFFFFF) |
| ON | Primary (#4F46E5) | White (#FFFFFF) |

## Checkbox

### Visual Design

```
┌─────────────────────────────────────┐
│ [ ] Unchecked                       │
│ [✓] Checked                         │
│ [●] Indeterminate                   │
└─────────────────────────────────────┘
```

### Colors

| State | Border Color | Fill Color |
|-------|-------------|------------|
| Unchecked | Gray (#6B7280) | Transparent |
| Checked | Primary (#4F46E5) | Primary (#4F46E5) |

## Form Actions

### Button Layout

```
┌─────────────────────────────────────┐
│                                     │
│  [Secondary Button]  [Primary Btn] │
│                                     │
└─────────────────────────────────────┘
```

### Button Variants

| Variant | Style | Use Case |
|---------|-------|----------|
| Primary | Solid primary color | Main action |
| Secondary | Outlined | Cancel/Back |
| Destructive | Solid error color | Delete |
| Text | Text only | Skip |

### Button Sizes

| Size | Height | Font Size | Padding |
|------|--------|-----------|---------|
| Small | 32px | 12px | 12px 16px |
| Medium | 44px | 14px | 12px 24px |
| Large | 52px | 16px | 16px 32px |

## Form Layout

### Standard Form

```
┌─────────────────────────────────────┐
│ Field 1                             │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Field 2                             │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Field 3                             │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│                                     │
│ [Cancel]              [Submit]      │
│                                     │
└─────────────────────────────────────┘
```

### Form with Sections

```
┌─────────────────────────────────────┐
│ Section Title                       │
├─────────────────────────────────────┤
│ Field 1                             │
│ Field 2                             │
├─────────────────────────────────────┤
│ Section Title 2                      │
├─────────────────────────────────────┤
│ Field 3                             │
│ Field 4                             │
├─────────────────────────────────────┤
│                                     │
│ [Cancel]              [Submit]      │
│                                     │
└─────────────────────────────────────┘
```

### Spacing

| Element | Spacing |
|---------|---------|
| Between fields | 16px |
| Section title to first field | 16px |
| Section gap | 24px |
| Form action buttons | 24px |

## Code Implementation

### CustomTextField Widget

```dart
class AdminTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool obscureText;

  const AdminTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
```

## Dependencies

### Required Imports
- app_colors.dart
- app_constants.dart
- flutter/material.dart

### Required Widgets
- TextFormField
- DropdownButtonFormField
- Checkbox
- Switch
- DatePicker