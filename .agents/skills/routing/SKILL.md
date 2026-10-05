---
name: routing
description: Define feature GoRouter paths, parameters, BlocProvider wiring, navigation, and authentication redirects in this Flutter app.
---

# Skill Playbook: /routing

Use this playbook for navigation changes. Read `lib/core/routes/app_routes.dart`, `app_route_redirect.dart`, affected feature routes/paths, and navigation call sites. Decide the URL shape, required parameters, auth requirement, and back-navigation behavior before editing.

## 1. Define paths and routes

Add the path/name in the feature's `presentation/routes/*_route_paths.dart` and the `GoRoute` or `ShellRoute` in its `*_routes.dart`. Read required `state.pathParameters`, query parameters, or `state.extra` using the feature's existing convention; validate values before casting when they may be absent. Compose a new feature route list in `AppRouter` only when needed.

## 2. Bind dependencies and guards

Provide route-scoped BLoCs with `BlocProvider(create: (_) => sl<FeatureBloc>())` or share an existing BLoC with `BlocProvider.value`, following neighboring routes. Dispatch an initial event only where the flow requires it. Keep login/protected-page redirects in `app_route_redirect.dart`; check unauthenticated, boot/loading, and authenticated paths to avoid loops. If deep links are affected, inspect Android/iOS link configuration before editing it.

## 3. Verify

Update navigation call sites and focused route/widget tests. Run `flutter analyze`. State any device-only deep-link behavior that remains unverified.
