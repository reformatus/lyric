# Lyric Test Harness Guide

## Quick Start

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/services/bank_api_test.dart

# Run tests with coverage
flutter test --coverage
```

## Test Directory Structure

```
test/
├── harness/              # Reusable test utilities
│   ├── test_harness.dart # Main entry point - exports everything
│   ├── test_config.dart  # Fake AppConfig with predictable values
│   ├── mock_dio.dart     # HTTP mocking utilities
│   ├── fake_messenger.dart # Fake MessengerService for UI feedback
│   ├── fake_platform.dart  # Fake PlatformInfo
│   └── test_database.dart  # In-memory database factory
├── services/             # Service layer tests
├── data/                 # Data layer / database tests
├── drift/                # Database migration tests (auto-generated)
└── ui/                   # Widget tests (future)
```

## Using the Test Harness

Import everything from a single file:

```dart
import '../harness/test_harness.dart';
```

### Basic Pattern with TestHarness

```dart
void main() {
  late TestHarness harness;

  setUp(() {
    harness = TestHarness();
  });

  tearDown(() {
    harness.dispose();
  });

  test('example test', () {
    // Access mocked Dio
    final dio = harness.container.read(dioProvider);
    
    // Access fake messenger to verify snackbars
    expect(harness.messenger.shownSnackBars, isEmpty);
    
    // Access platform info
    expect(harness.platform.isDesktop, isTrue);
  });
}
```

### Mocking HTTP Responses

Use `RecordingHttpAdapter` to control responses and verify requests:

```dart
setUp(() {
  harness = TestHarness();
  
  final recorder = RecordingHttpAdapter(
    responseBuilder: (options) {
      if (options.path.contains('/songs')) {
        return ResponseBody.fromString('[{"uuid":"1","title":"Song"}]', 200);
      }
      return ResponseBody.fromString('{}', 200);
    },
  );
  
  harness.mockDio.httpClientAdapter = recorder;
});

test('fetches songs', () async {
  final dio = harness.container.read(dioProvider);
  final response = await dio.get('https://api.example.com/songs');
  
  // Verify the request was made
  expect(recorder.requests, hasLength(1));
  expect(recorder.requests.first.path, contains('/songs'));
});
```

### Testing with In-Memory Database

```dart
late LyricDatabase testDb;

setUp(() {
  testDb = createTestDatabase();
});

tearDown(() async {
  await testDb.close();
});

test('database operations', () async {
  // Use testDb instead of global db
  await testDb.banks.insertOne(...);
  
  // Clean slate between tests
  await testDb.clearAllTables();
});
```

### Testing MessengerService Interactions

When testing code that shows snackbars or banners:

```dart
test('shows error snackbar on failure', () async {
  // Trigger the action that should show a snackbar
  await someServiceThatShowsSnackbar();
  
  // Verify
  expect(harness.messenger.shownSnackBars, hasLength(1));
  // You can also inspect the snackbar content if needed
});
```

## Key Differences from Production

| Production | Test |
|------------|------|
| `appConfig` (from config.dart) | `testAppConfig` with predictable values |
| `appDio` (real HTTP client) | `createMockDio()` with `MockHttpAdapter` |
| `messengerService` (real scaffold key) | `FakeMessengerService` (records calls) |
| `platformInfoProvider` (real platform) | `createTestPlatformInfo()` (configurable) |
| `db` (persistent SQLite) | `createTestDatabase()` (in-memory) |

## Writing New Tests

### Unit Tests (Services/Logic)

1. Create file in `test/services/` or `test/data/`
2. Use `TestHarness` for provider overrides
3. Mock external dependencies (HTTP, database)
4. Test one behavior per test case

### Widget Tests

For widget tests, use `ProviderScope` with overrides:

```dart
testWidgets('widget shows data', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dioProvider.overrideWithValue(createMockDio()),
        // ... other overrides
      ],
      child: MaterialApp(home: MyWidget()),
    ),
  );
});
```

## Tips for AI Agents

1. **Always use TestHarness** - it handles provider overrides and cleanup
2. **Don't use global singletons in tests** - use the harness's container
3. **Mock HTTP at adapter level** - use `RecordingHttpAdapter` for inspection
4. **Test database separately** - use `createTestDatabase()` for isolation
5. **Clean up in tearDown** - call `harness.dispose()` to prevent leaks
6. **Check existing tests** - follow patterns in `test/services/` for consistency

## Extending the Harness

To add new fakes:

1. Create fake in `test/harness/fake_*.dart`
2. Export from `test_harness.dart`
3. Add override in `TestHarness` constructor if it's a provider
4. Document usage in this file

## Production Dependencies That Are Mockable

| Dependency | Provider | Mock Strategy |
|------------|----------|---------------|
| HTTP client | `dioProvider` | `MockHttpAdapter` |
| Platform detection | `platformInfoProvider` | `createTestPlatformInfo()` |
| Snackbars/Banners | `messengerServiceProviderProvider` | `FakeMessengerService` |
| Database | (use `createTestDatabase()`) | In-memory SQLite |
| App config | (import `testAppConfig`) | Predictable values |

## Running Tests in CI

The test suite is designed to run without external dependencies:
- No network calls (all HTTP mocked)
- No persistent storage (in-memory DB)
- No platform-specific APIs (mocked)

However we do have a dependency: To run CLI tests, you need the sqlite development tools.
On Debian/Ubuntu/derivatives, install:
```bash
sudo apt-get update && sudo apt-get install -y libsqlite3-dev
```

```yaml
# Example CI step
- name: Run tests
  run: flutter test --coverage
```
