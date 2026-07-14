---
name: wassaly-screenutil-audit
description: Scans widget code files to find raw integer/double layout numbers and helps refactor them to use ScreenUtil extensions.
---

# Wassaly ScreenUtil Audit Skill

Use this skill to audit UI visual layout widgets and convert hardcoded layout coordinates or font sizes to responsive extensions.

## 1. Allowed and Disallowed Formats

### Height and Vertical Spacing
*   ❌ `height: 24` or `height: 24.0`
*   ✅ `height: 24.h`
*   ❌ `SizedBox(height: 10)`
*   ✅ `SizedBox(height: 10.h)`

### Width and Horizontal Spacing
*   ❌ `width: 32` or `width: 32.0`
*   ✅ `width: 32.w`
*   ❌ `SizedBox(width: 8)`
*   ✅ `SizedBox(width: 8.w)`

### Edge Insets (Padding & Margin)
*   ❌ `EdgeInsets.all(16)`
*   ✅ `EdgeInsets.all(16.r)` (or matching `.w` / `.h` depending on axis constraints)
*   ❌ `EdgeInsets.symmetric(horizontal: 20, vertical: 10)`
*   ✅ `EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)`

### Borders and Border Radii
*   ❌ `BorderRadius.circular(8)`
*   ✅ `BorderRadius.circular(8.r)`

### Typography (Font Sizes)
*   ❌ `fontSize: 14`
*   ✅ `fontSize: 14.sp`

## 2. Refactoring Process
1. Locate target widget code.
2. Read the imports to ensure `import 'package:flutter_screenutil/flutter_screenutil.dart';` is present.
3. Replace raw numeric expressions with their responsive extensions (`.w`, `.h`, `.r`, `.sp`).
4. Validate build configurations.
