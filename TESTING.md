# Detailed Testing Guide

This document provides a deep dive into how to write and maintain tests for the ShopBloc project. We follow the **Testing Pyramid**: a broad base of Unit tests, a middle layer of Widget tests, and a focused peak of Integration tests.

---

## 1. Unit Testing (Logic & Data)
**Purpose**: To verify that your business logic (BLoCs, Use Cases) and data mapping (Repositories) work correctly in total isolation.

### The Mocktail Pattern
We use `mocktail` for mocking. Never use real network or database classes in unit tests.

```dart
// 1. Define the mock
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepo;
  late GetProductsUseCase useCase;

  setUp(() {
    mockRepo = MockProductRepository();
    useCase = GetProductsUseCase(mockRepo);
  });

  test('should return products from repository', () async {
    // 2. Arrange: Stub the method call
    when(() => mockRepo.getProducts())
        .thenAnswer((_) async => Result.success(tProducts));

    // 3. Act: Execute the logic
    final result = await useCase.execute();

    // 4. Assert: Verify the outcome
    expect(result, Result.success(tProducts));
    verify(() => mockRepo.getProducts()).called(1);
  });
}
```

### BLoC Testing with `bloc_test`
BLoCs are state machines. We test the **sequence of states** emitted in response to events.

*   **build**: Initialize the BLoC and stub its dependencies.
*   **act**: Trigger the event you want to test.
*   **expect**: List the states you expect in chronological order.
*   **verify**: Check if dependencies were called correctly.

```dart
blocTest<ProductBloc, ProductState>(
  'emits [Loading, Success] when products are fetched successfully',
  build: () {
    when(() => mockUseCase.execute()).thenAnswer((_) async => Result.success(tProducts));
    return ProductBloc(getProducts: mockUseCase);
  },
  act: (bloc) => bloc.add(const ProductsRequested()),
  expect: () => [
    const ProductState.loading(),
    ProductState.success(products: tProducts),
  ],
);
```

---

## 2. Widget Testing (UI & Interaction)
**Purpose**: To ensure individual widgets render correctly and respond to user input (taps, text entry).

### The `pumpApp` Helper
Standard `tester.pumpWidget` fails in this project because our widgets depend on **Theme**, **Localization**, and **BLoC Providers**. Use `pumpApp` (defined in `test/helpers/test_helpers.dart`).

```dart
await tester.pumpApp(
  const MyWidget(),
  authBloc: mockAuthBloc,       // Injects MockAuthBloc into the tree
  productBloc: mockProductBloc, // Injects MockProductBloc
);
```

### Common Actions & Matchers
*   **Finding**: `find.text('Login')`, `find.byType(TextField)`, `find.byIcon(Icons.add)`.
*   **Interacting**: `await tester.tap(finder)`, `await tester.enterText(finder, 'text')`.
*   **Settling**: `await tester.pumpAndSettle()` waits for all animations/frames to finish. Use `tester.pump(Duration)` for specific delays.
*   **Network Images**: If your widget uses `Image.network`, you MUST wrap the test in `mockNetworkImages`:
    ```dart
    await mockNetworkImages(() async {
      await tester.pumpApp(const ProductCard(product: tProduct));
      expect(find.byType(Image), findsOneWidget);
    });
    ```

---

## 3. Integration Testing (E2E)
**Purpose**: To test the "Happy Path" of a feature by running the real app on a device or emulator.

### Workflow
1.  **Initialize**: `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.
2.  **Launch**: Call `app.main()` to start the actual application entry point.
3.  **Simulate**: Use the `tester` to act like a real user.
4.  **Wait**: Integration tests run slower than widget tests; use `pumpAndSettle()` frequently.

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete Login Flow', (tester) async {
    app.main(); 
    await tester.pumpAndSettle();

    // 1. Enter Credentials
    await tester.enterText(find.byKey(const Key('user_field')), 'emilys');
    await tester.enterText(find.byKey(const Key('pass_field')), 'emilyspass');
    
    // 2. Tap Login
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // 3. Verify Navigation to Home
    expect(find.text('Categories'), findsOneWidget);
  });
}
```

---

## Best Practices
1.  **Isolation**: Each test should be independent. Use `setUp` to reset mocks.
2.  **Deterministic**: Avoid `Math.random()` or current timestamps in tests.
3.  **Meaningful Descriptions**: `test('should do X when Y happens')` is better than `test('test 1')`.
4.  **Golden Tests**: For pixel-perfect UI verification, consider adding Golden Tests (not currently in this suite).
5.  **Clean Up**: If you create temporary files or listeners, clean them up in `tearDown`.

## Running Tests
*   **Terminal**: `flutter test`
*   **VS Code**: Use the "Testing" tab or click the "Run" icon above `void main()`.
*   **CI**: Every commit to `main` or `develop` triggers a full test run in GitHub Actions.
