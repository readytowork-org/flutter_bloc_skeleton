---
name: presentation
description: Build feature presentation layers — pages, routing, BLoC wiring, and widget composition — following the project's feature-first clean architecture.
---

# Skill Playbook: /presentation

Use this playbook for building or modifying a feature's presentation layer. Read the affected feature's existing pages, routes, BLoCs, and widgets first. The presentation layer handles user interaction, state management, and visual layout — it depends on domain contracts and never imports data-layer code directly.

## 1. Pages — `lib/features/<feature>/presentation/pages/`

Pages are thin shells that wrap a single organism view:

```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPageView();
  }
}
```

- Pages provide `Scaffold`, `AppBar`, and navigation context.
- For pages that need to dispatch an initial event, use `StatefulWidget` with `initState()`:
  ```dart
  @override
  void initState() {
    super.initState();
    context.read<GetProductByIdBloc>().add(GetProductByIdRequested(id: id));
  }
  ```
- Keep pages lean — delegate all UI to organism views.

## 2. Routing — `lib/features/<feature>/presentation/routes/`

Each feature defines its own route paths and route list:

- **`*_route_paths.dart`** — enum with path and name constants:
  ```dart
  enum ProductRoute {
    product('/', 'Product'),
    productDetail('/:id', 'ProductDetail'),
    addProduct('/add', 'AddProduct'),
    editProduct('/edit/:id', 'EditProduct');
  }
  ```

- **`*_routes.dart`** — `GoRoute` or `ShellRoute` list:
  ```dart
  class ProductRoutes {
    static final List<GoRoute> routes = [
      GoRoute(
        path: ProductRoute.product.path,
        builder: (context, state) => const ProductPage(),
        routes: [
          GoRoute(
            path: ProductRoute.productDetail.path,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailPage(id: id);
            },
          ),
        ],
      ),
    ];
  }
  ```

- Compose feature routes in `lib/core/routes/app_routes.dart`.
- Change `app_route_redirect.dart` only when authentication behavior changes.

## 3. BLoC Wiring

- **Page-scoped BLoCs:** Wrap with `BlocProvider(create: (_) => sl<FeatureBloc>())` at the page or route boundary.
- **Shared BLoCs:** Use `BlocProvider.value` for singleton BLoCs registered in GetIt.
- **MultiBlocProvider:** Use at `ShellRoute` level when multiple BLoCs are shared across nested routes.
- **Factory vs singleton:** Page-specific BLoCs use `registerFactory`; shared BLoCs use `registerLazySingleton`.

## 4. Widget Composition

Compose pages from atomic design widgets (see `/widget` skill):

- **Organisms** form the main body of a page (e.g., `ProductView`, `LoginPageView`).
- **Molecules** are composed within organisms (e.g., `ProductCard`, `ProductSearchBar`).
- **Atoms** are the smallest building blocks (e.g., `AppButton`, `InputField`).
- **Private sub-widgets:** File-private classes (`_FieldLabel`, `_InfoChip`) at the bottom of organism files for section-specific UI.

## 5. BLoC State Rendering

Choose the right consumption pattern:

| Pattern | Use When |
| :--- | :--- |
| `BlocStateBuilder<B, S>` | Rendering all states of a `BaseState` union |
| `BlocConsumer<B, S>` | Need both listener (side effects) and builder (UI) |
| `BlocListener` + `BlocBuilder` | Listener and builder at different tree positions |
| `AppBlocButton<B, S>` | Self-contained BLoC-aware button |
| `BlocPaginationView<T, B>` | Infinite-scroll paginated lists |

- Use `state.maybeWhen(...)` or `switch` on Freezed state unions.
- Emit side effects (SnackBar, navigation) in `listener`, not `builder`.

## 6. Navigation

Use GoRouter context extensions:

```dart
context.push('/product/${product.id}');
context.go('/login');
context.pop();
```

- Define paths in `*_route_paths.dart` enums — never hardcode route strings.
- Validate path parameters before casting: `state.pathParameters['id']!`.

## 7. Code Generation

After creating or editing any `@freezed` event or state class, run `make generate`. Never hand-edit `*.freezed.dart` files.

## 8. Testing

- **Widget tests:** Use `pumpApp` from `test/helpers/test_helpers.dart` with mock BLoCs.
- **Route tests:** Verify navigation call sites and route parameter passing.
- **State-driven tests:** Use `whenListen` to simulate state transitions and assert UI reactions.

## 9. Validation

Run focused tests, `dart format --output=none --set-exit-if-changed lib test`, and `flutter analyze`. Report what changed and which checks passed or could not run.
