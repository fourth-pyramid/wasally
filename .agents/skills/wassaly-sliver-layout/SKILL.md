---
name: wassaly-sliver-layout
description: Ensures high-level pages use CustomScrollView, SliverAppBar, SliverList, and SliverGrid to support premium collapsible scroll structures.
---

# Wassaly Sliver Layout Skill

Use this skill when designing or refactoring high-level screen pages in the Wassaly project. It enforces the use of sliver-based layouts for fluid scroll motions and robust scroll performance.

## 1. Why Slivers?
1.  **Unified Scroll Controllers**: Prevents conflicts when nesting list/grid views within a scrollable column.
2.  **Premium Aesthetics**: Supports collapsible headers, expandable banners, and pinned navigation bars seamlessly.
3.  **Efficiency**: Builds offscreen widgets lazily using silver-specific delegates.

---

## 2. Core Rules & Constraints

1.  **Main Layout Container**: Always use `CustomScrollView` as the top-level scrollable widget rather than standard `SingleChildScrollView` or nested `ListView`/`GridView` elements.
2.  **Headers**: Use `SliverAppBar` to implement flexible collapsible app headers.
3.  **Standard Widgets**: Wrap raw non-sliver widgets in `SliverToBoxAdapter` to place them safely inside a `CustomScrollView`.
4.  **Lists**: Use `SliverList` with `SliverChildBuilderDelegate`.
5.  **Grids**: Use `SliverGrid` with `SliverGridDelegateWithFixedCrossAxisCount` (or similar) and a builder delegate.

---

## 3. Boilerplate Template

Below is the standard page structure for a new screen:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // Ensure full height scroll under status bar
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Sliver App Bar
            SliverAppBar(
              expandedHeight: 200.h,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Feature Header', style: TextStyle(fontSize: 18.sp)),
                background: Image.network(
                  'https://example.com/banner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. SliverToBoxAdapter for non-sliver components (e.g. section titles)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'Explore Products',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 3. SliverGrid for multi-column grids
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    child: Center(child: Text('Product Item $index')),
                  );
                },
                childCount: 4,
              ),
            ),

            // 4. Another SliverToBoxAdapter
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'Service Providers',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 5. SliverList for list structures
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    title: Text('Provider #$index'),
                    subtitle: const Text('Rating: ⭐⭐⭐⭐⭐'),
                  );
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
