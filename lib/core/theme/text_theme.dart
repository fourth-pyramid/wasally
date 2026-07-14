import 'package:flutter/material.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

const String _fontFamily = 'Cairo';

/// Defines the full Material 3 typescale for the application.
///
/// Prefer accessing styles through [BuildContext] extensions:
/// ```dart
/// Text('Hello', style: context.textTheme.titleLarge);
/// ```
TextTheme buildTextTheme() {
  final baseTextTheme = TextTheme(
    // ── Display ──────────────────────────────────────────────────────────────
    // Use for the largest, most impactful text on a screen.
    // Typically reserved for hero/marketing sections, splash screens,
    // or short one-word statements. Never use for body copy.

    /// 57 sp — Largest display text.
    /// Use for: splash screen titles, giant counters, hero numbers.
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 57.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),

    /// 45 sp — Mid-size display text.
    /// Use for: prominent feature headlines, onboarding first-screen titles.
    displayMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 45.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    /// 36 sp — Smallest display text.
    /// Use for: section-level hero text, large marketing callouts.
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 36.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    // ── Headline ─────────────────────────────────────────────────────────────
    // Use for page/screen-level headings. Slightly smaller than Display —
    // works well as the primary title of a full page or major section.

    /// 32 sp — Large page-level heading.
    /// Use for: main screen titles (e.g. "My Profile"), large dialog headers.
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    /// 28 sp — Standard page-level heading.
    /// Use for: AppBar titles on content-heavy screens, sheet headers.
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    /// 24 sp — Compact page-level heading.
    /// Use for: section headings within a scrollable page, card group titles.
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    // ── Title ─────────────────────────────────────────────────────────────────
    // Use for component-level titles and prominent labels inside cards,
    // lists, or dialogs. More emphasis than body, less than headline.

    /// 22 sp — Prominent component title.
    /// Use for: AppBar titles (standard), large list-section headers,
    ///          dialog/modal titles.
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),

    /// 16 sp — Standard component title.
    /// Use for: ListTile titles, card headings, tab labels, dropdown labels.
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),

    /// 14 sp — Compact component title.
    /// Use for: dense list item titles, chip labels, form field labels,
    ///          subtitle of a section.
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    // ── Body ──────────────────────────────────────────────────────────────────
    // Use for reading/content text. Optimised for legibility at comfortable
    // reading sizes. Default for paragraphs and descriptions.

    /// 16 sp — Primary body text.
    /// Use for: main paragraph text, message bubbles, article content,
    ///          default Text() inside cards.
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),

    /// 14 sp — Standard body text (most common).
    /// Use for: secondary descriptions, ListTile subtitles, form helper text,
    ///          dialog body copy. This is the workhorse style.
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),

    /// 12 sp — Small body / caption text.
    /// Use for: captions under images, timestamps, metadata, fine print,
    ///          secondary info below a ListTile.
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),

    // ── Label ─────────────────────────────────────────────────────────────────
    // Use for UI control labels, buttons, and navigation items.
    // NOT for body copy — these are designed to label interactive elements.

    /// 14 sp — Button and prominent control label.
    /// Use for: ElevatedButton / TextButton / OutlinedButton text,
    ///          navigation bar labels (selected), tab bar labels.
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    /// 12 sp — Standard control label.
    /// Use for: chip text, badge text, tooltip text, navigation rail labels,
    ///          input counter text, overline headings.
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),

    /// 11 sp — Smallest control label.
    /// Use for: dense navigation labels, very small badges, annotation text,
    ///          data table column headers. Avoid for reading-heavy content.
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  return baseTextTheme;
}
