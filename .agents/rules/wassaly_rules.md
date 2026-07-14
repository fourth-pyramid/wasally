# Workspace Rules for Wassaly Clean Architecture

Whenever you are working on the Wassaly project, you MUST strictly follow these guidelines and leverage the corresponding local skills:

## 1. Clean Architecture & Structure
*   **Directory Layout**: All features must follow the 3-Layer Clean Architecture structure (`domain`, `data`, `presentation`).
*   **Automation**: Use the `clean-flutter-generator` skill to scaffold feature directories and generate standard base code.

## 2. State Management & Presentation
*   **Pattern**: Use `flutter_bloc` for tracking event/state flows.
*   **State Rules**: Every BLoC state must implement the 6 standard states: `Initial`, `Loading`, `Success`, `Failure/Error`, `Empty`, and `Refreshing`.
*   **Optimization**: Always prefer `BlocSelector` over `BlocBuilder` to minimize widget rebuilds.
*   **Guidance**: Refer to the `wassaly-bloc-helper` skill for implementing safe Bloc triggers, tests, and selector templates.

## 3. Remote REST APIs & Data Handling
*   **Client**: Use `dio` with custom interceptors and error logging.
*   **DTO Models**: Remote models must extend domain entities and provide `fromJson`/`toJson` mappings.
*   **Exceptions**: Network errors should throw local exceptions (e.g. `ServerException`), which are mapped to domain `Failure` instances.
*   **Guidance**: Refer to the `wassaly-api-generator` skill when constructing remote data sources and serialization logic.

## 4. UI/UX, Sizing, & Layouts
*   **Responsiveness**: Always use `flutter_screenutil` extensions (e.g. `.w`, `.h`, `.sp`, `.r`) for margins, padding, fonts, and dimensions. Refer to the `wassaly-screenutil-audit` skill to scan and refactor hardcoded sizing.
*   **Scrolling UI**: Use `CustomScrollView` with `SliverAppBar`, `SliverList`, and `SliverGrid` for high-level screen pages. Refer to the `wassaly-sliver-layout` skill to build premium scrolling templates.
*   **Load Indicators**: Use `skeletonizer` for shimmer loading indicators and `flutter_animate` for page transitions.

## 5. Multi-Language & Translation
*   **Resource Access**: Access user-facing strings dynamically via `context.l10n`.
*   **Parity**: Ensure key parity between English (`app_en.arb`) and Arabic (`app_ar.arb`) files and compile using `flutter gen-l10n`. Refer to the `wassaly-localization-helper` skill.

## 6. Connectivity Tracking
*   **Strategy**: Check connectivity status before executing network tasks to separate "no internet" states from "server down" states.
*   **Execution**: Use `runTask` wrappers and listen to status recovery streams inside BLoCs. Refer to the `wassaly-network-tracker` skill.
