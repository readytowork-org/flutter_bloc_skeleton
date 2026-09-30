---
name: widget
description: Create and test individual Flutter widgets following atomic design, shared widget usage, responsive patterns, and widget testing conventions.
---

# Skill Playbook: /widget

Use this playbook for creating, refactoring, or testing individual widgets. Read existing widgets in `lib/shared/widgets/` and the target feature's `presentation/widgets/` first. Widgets are reusable, modular visual components — they render state and dispatch events but never call Dio, storage, or use cases directly.

## 1. Atomic Design Placement

Every widget belongs to one of three tiers:

| Tier | Location | Scope | Examples |
| :--- | :--- | :--- | :--- |
| **Atoms** | `widgets/atoms/` | Smallest reusable building blocks | Buttons, input fields, chips, tags, avatars, rating bars |
| **Molecules** | `widgets/molecules/` | Composed atoms functioning as a unit | Cards, search bars, headers, info cards |
| **Organisms** | `widgets/organisms/` | Complex composed widgets forming page sections | Full page views, pagination views, detail sections |

- **Shared vs feature-specific:** If a widget is used across features, place it in `lib/shared/widgets/`. If it belongs to one feature, place it under that feature's `presentation/widgets/`.
- **File naming:** One widget per file, `snake_case.dart`, class name `PascalCase`.

## 2. Shared Widgets (lib/shared/widgets/)

Before creating a new widget, check if a shared equivalent exists:

| Shared Widget | Purpose |
| :--- | :--- |
| `AppButton` | Multi-variant button with loading state |
| `AppBlocButton<B, S>` | BLoC-aware button with `BlocConsumer` |
| `BlocStateBuilder<B, S>` | Generic state renderer for `BaseState` unions |
| `BlocPaginationView<T, B>` | Infinite-scroll pagination |
| `RefreshGridView` / `RefreshListView` | Pull-to-refresh lists/grids |
| `InputField` | Form field with validation and password toggle |
| `ImageView` | Network image with error fallback |
| `SearchInputBar` | Styled search field |
| `CircularLoadingIndicator` | Scaled loading spinner |
| `LocaleSwitcher` | FAB for locale toggle |
| `PageNotFoundView` | 404 page |

Prefer reusing shared widgets over creating duplicates.

## 3. Widget State Consumption

Widgets consume BLoC state — they never contain business logic:

| Pattern | Use When |
| :--- | :--- |
| `BlocStateBuilder<B, S>` | Rendering all states of a `BaseState` union |
| `BlocConsumer<B, S>` | Need both listener (side effects) and builder (UI) |
| `BlocListener` + `BlocBuilder` | Listener and builder at different tree positions |
| `AppBlocButton<B, S>` | Self-contained BLoC-aware button |
| `context.watch<T>()` | Reacting to Cubit/state changes |
| `context.read<T>().add(...)` | Dispatching events |

- Use `state.maybeWhen(...)` or `switch` on Freezed state unions.
- Never mutate collections held by emitted state.

## 4. Responsive & Theme Extensions

Always use context extensions instead of raw `Theme.of(context)` or `MediaQuery.of(context)`:

```dart
// Theme
context.titleLarge, context.bodySmall, context.labelLarge
context.primary, context.secondary, context.errorColor, context.background

// Responsive breakpoints
context.width, context.height, context.size
context.isMobile      // <= 500
context.isSmallTablet // 500–650
context.isTablet      // 650–1024
context.isDesktop     // >= 1024

// Dialogs
context.showSnackBar(message)
context.showBottomSheet(child)
```

## 5. Local State

Use `StatefulWidget` for local UI state (form keys, debounce timers, scroll controllers):

- Initialize controllers and keys in `initState()`.
- Always dispose controllers, timers, and keys in `dispose()`.
- Use `setState()` for local state changes; do not create a BLoC for purely local UI state.

## 6. Widget Testing

Use `pumpApp` from `test/helpers/test_helpers.dart`:

```dart
await tester.pumpApp(
  const MyWidget(),
  authBloc: mockAuthBloc,
  productBloc: mockProductBloc,
);
```

### Mock Setup

- Use `MockBloc` from `bloc_test` for BLoC mocks.
- Call `registerAuthFallbacks()` in `setUpAll()` for `Fake*Event`/`Fake*State` types.
- Stub default state: `when(() => mockBloc.state).thenReturn(const XxxState.initial())`.
- Stub stream: `when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty())`.
- Simulate transitions: `whenListen(mockBloc, Stream.fromIterable([...]), initialState: ...)`.

### Network Images

```dart
await mockNetworkImages(() async {
  await tester.pumpApp(const ProductCard(product: tProduct));
  expect(find.byType(Image), findsOneWidget);
});
```

### Assertions

- Finders: `find.text()`, `find.byType()`, `find.byWidgetPredicate()`, `find.byKey()`
- Interactions: `await tester.tap(finder)`, `await tester.enterText(finder, 'text')`
- Settling: `await tester.pumpAndSettle()` for animations
- Event verification: `verify(() => mockBloc.add(...)).called(1)`

## 7. Validation

Run focused widget tests, `dart format --output=none --set-exit-if-changed lib test`, and `flutter analyze`.
