ن ---
name: wassaly-localization-helper
description: Guides updating, verifying, and syncing localized ARB files (Arabic and English) with correct parameter passing and plurals formatting.
---

# Wassaly Localization Helper Skill

Use this skill when adding or updating localized text in the Wassaly project.

## 1. File Synchronization
Whenever a new localization string is added, it must be added to BOTH files:
*   `lib/l10n/app_en.arb` (English translation)
*   `lib/l10n/app_ar.arb` (Arabic translation)

The key names must be identical. If one file has a key, the other must have it too.

## 2. Pluralization Rules (ICU Format)
Arabic has complex plural rules (`zero`, `one`, `two`, `few`, `many`, `other`). Ensure you configure them properly in both files.

Example ARB syntax:
```json
"profile_orders_count": "{count, plural, =0{لا توجد طلبات} =1{طلب واحد} =2{طلبان} few{{count} طلبات} many{{count} طلب} other{{count} طلب} }"
```

In English:
```json
"profile_orders_count": "{count, plural, =0{No orders} =1{1 order} other{{count} orders}}"
```

## 3. Code Generation
After editing localization files, run this build command to generate localization Dart classes:
```bash
flutter gen-l10n
```
Use the output context helpers in UI widgets:
```dart
Text(context.l10n.profile_orders_count(ordersCount))
```
