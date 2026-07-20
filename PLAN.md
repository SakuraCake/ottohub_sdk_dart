# OTTOhub SDK Flutter — Implementation Plan

> **Goal**: Build a Flutter SDK package (`ottohub_sdk_flutter`) wrapping OTTOhub HTTP APIs into a typed Dart API.
>
> API docs in `docs/` are the source of truth — all have been verified against the live API at `https://api.ottohub.cn/api`.
>
> Phase 1: Auth module. Additional modules (Video, Following, Block, Danmaku, Channel, Moderation) follow the same pattern.

---

## 1. Architecture

```
┌──────────────────────────────────────────────┐
│ Consumer app                                 │
│   final client = OttohubClient(token: ...)    │
│   final resp = await client.auth.login(...)   │
└──────────────┬───────────────────────────────┘
               │
┌──────────────▼───────────────────────────────┐
│ OttohubClient (entry point)                  │
│   - holds AuthApi, VideoApi, ...             │
│   - holds _token (in-memory, no persistence) │
│   - injectable Dio for test mocking          │
└──────────────┬───────────────────────────────┘
               │
┌──────────────▼───────────────────────────────┐
│ AuthApi extends BaseApi                      │
│   - login() → LoginResponse                  │
│   - register() → void                        │
│   - sendRegisterVerificationCode() → void    │
│   - sendPasswordResetVerificationCode() → void│
│   - resetPassword() → void                   │
│   - signIn() → String                        │
└──────────────┬───────────────────────────────┘
               │
┌──────────────▼───────────────────────────────┐
│ BaseApi (abstract)                            │
│   - get / post / put / delete                │
│   - token injection (GET=query, POST=body)   │
│   - response validation (status="error"→throw)│
└──────────────┬───────────────────────────────┘
               │
┌──────────────▼───────────────────────────────┐
│ Models (json_serializable)                   │
│   - LoginResponse, VideoDetail, ...          │
│   - fieldRename: FieldRename.snake           │
│   - .g.dart generated & committed            │
└──────────────────────────────────────────────┘
```

### Key decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| HTTP client | **Dio** | Interceptors, test mockability |
| Serialization | **json_annotation + json_serializable** | Type safety, zero-boilerplate |
| `.g.dart` committed | **Yes** | SDK consumers don't run build_runner |
| Token storage | **In-memory** via `set token()` | SDK doesn't depend on platform storage; consumer manages persistence |
| Base URL | **`https://api.ottohub.cn/api`** default, constructor override | Flexibility for staging/testing |
| Response `data` unwrap | **Per-method, no generic unwrap** | Inconsistent API shape (root-level, `data` wrapper, or list) |
| `pubspec.lock` | **Committed during dev** (remove from .gitignore) | Lock dependency versions; reinstate before publish |

---

## 2. File Structure

```
ottohub_sdk_flutter/
├── lib/
│   ├── ottohub_sdk_flutter.dart          # barrel file — exports public API
│   └── src/
│       ├── client.dart                   # OttohubClient
│       ├── base_api.dart                 # abstract BaseApi (get/post/put/delete + validation)
│       ├── exceptions/
│       │   └── api_exception.dart        # ApiException(errorCode)
│       ├── models/
│       │   └── auth/
│       │       ├── login_response.dart   # @JsonSerializable model
│       │       └── login_response.g.dart # generated
│       └── apis/
│           └── auth_api.dart             # AuthApi extends BaseApi
├── test/
│   ├── ottohub_sdk_flutter_test.dart     # placeholder (kept from scaffold)
│   └── src/
│       ├── models/
│       │   └── auth/
│       │       └── login_response_test.dart
│       └── apis/
│           └── auth_api_test.dart
├── pubspec.yaml
├── pubspec.lock (committed during dev)
├── .gitignore
├── .dart_tool/
├── build/
└── ...
```

---

## 3. Each File — Detailed Design

### 3.1 `pubspec.yaml`

```yaml
name: ottohub_sdk_flutter
description: "OTTOhub HTTP API SDK"
version: 0.0.1

environment:
  sdk: ^3.12.2
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  dio: ^5.10.0
  json_annotation: ^4.12.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  json_serializable: ^6.14.0
  build_runner: ^2.15.2
```

Dependencies rationale:
- **dio**: Only stable Dio v5. `^5.10.0` gets the latest 5.x with all bugfixes.
- **json_annotation**: Runtime dependency for `@JsonSerializable` / `@JsonKey` annotations.
- **json_serializable / build_runner**: Dev-only; SDK consumers never need to run codegen.

### 3.2 `.gitignore`

```
# Remove /pubspec.lock from ignore list — commit during development
# /pubspec.lock
**/doc/api/
.dart_tool/
.flutter-plugins-dependencies
/build/
/coverage/
```

### 3.3 `lib/ottohub_sdk_flutter.dart` — barrel file

```dart
/// OTTOhub SDK Flutter
library ottohub_sdk_flutter;

export 'src/client.dart';
export 'src/exceptions/api_exception.dart';
export 'src/models/auth/login_response.dart';
```

Public API surface:
- `OttohubClient` — main entry point
- `ApiException` — all SDK errors
- `LoginResponse` — model (consumers may want to inspect fields directly)

Other models/APIs are accessed through `client.auth.login()` etc. and don't need separate exports unless explicitly consumed.

### 3.4 `lib/src/exceptions/api_exception.dart`

```dart
class ApiException implements Exception {
  final String errorCode;
  const ApiException(this.errorCode);

  @override
  String toString() => errorCode;
}
```

No stack trace wrapping — consumers get the error message as-is from the API.
Common values: `error_token`, `missing_argument`, `system_error`, `too_many_requests`.

### 3.5 `lib/src/base_api.dart` — core abstraction

**Token injection rules** (from `old_api.md` verification):

| HTTP method | Token location |
|-------------|---------------|
| GET | `queryParameters['token']` |
| POST (JSON body) | `data['token']` |
| POST (FormData) | `formData.fields` appended |
| PUT | `data['token']` |
| DELETE | `queryParameters['token']` (preferred) or `data['token']` (fallback) |

**Response validation** — every response goes through `_validate()`:

```dart
Map<String, dynamic> _validate(Response response) {
  final data = response.data;
  if (data is! Map<String, dynamic>) {
    throw ApiException('unexpected_response_format');
  }
  if (data['status'] == 'error') {
    throw ApiException(data['message'] as String? ?? 'unknown_error');
  }
  return data;
}
```

- Why check `status == 'error'` here instead of a Dio interceptor?
  - More explicit, easier to test, single responsibility.
- Why return `Map<String, dynamic>` with `status` still in it?
  - The model's `fromJson` ignores unknown keys. Callers who need `status` have it. Clean separation.
- What about responses that return a list (e.g. danmaku)?
  - Those API methods will handle the list directly, not through `_validate`. BaseApi provides `_validate` and also a raw response passthrough if needed. Actually, the current `get/post/put/delete` methods all call `_validate`. For endpoint-specific cases, we can add a `getRaw()` or similar. **For Auth module, this isn't needed** — all auth endpoints return a Map.

**Complete method signatures**:

```dart
abstract class BaseApi {
  BaseApi(this._dio, this._getToken);

  final Dio _dio;
  final String? Function() _getToken;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data, FormData? formData});
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> delete(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data});
}
```

Implementation detail for token injection in `post` with `FormData`: check `formData != null` and add field before calling `_dio.post(path, data: formData)`. The token is a `MapEntry('token', token)`.

### 3.6 `lib/src/models/auth/login_response.dart`

**Real API response shape** (verified via `Invoke-RestMethod`):

```json
{
  "status": "success",
  "uid": "19015",
  "token": "ZEMr...",
  "avatar_url": "https://...",
  "cover_url": "https://...",
  "if_today_first_login": "no",
  "email": "user@example.com",
  "is_audit": 0,
  "is_admin": 0
}
```

Notable observations:
- `uid` is **String** (`"19015"`), not int — despite docs showing `"uid": 123`.
- `if_today_first_login` is `"yes"` / `"no"` (String), not bool.
- `is_audit` / `is_admin` are int (`0` / `1`).

**Model**:

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  final String uid;
  final String token;
  final String? avatarUrl;
  final String? coverUrl;
  final String? ifTodayFirstLogin;
  final String? email;
  final int? isAudit;
  final int? isAdmin;

  const LoginResponse({
    required this.uid,
    required this.token,
    this.avatarUrl,
    this.coverUrl,
    this.ifTodayFirstLogin,
    this.email,
    this.isAudit,
    this.isAdmin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
```

- `fieldRename: FieldRename.snake` auto-converts `avatar_url` ↔ `avatarUrl`. No manual `@JsonKey(name:)` needed.
- All fields are optional except `uid` and `token` (always present on success).
- Callers who need `if_today_first_login` from sign-in can check `resp.ifTodayFirstLogin == 'yes'`.

### 3.7 `lib/src/apis/auth_api.dart`

```dart
class AuthApi extends BaseApi {
  AuthApi(super.dio, super.getToken);

  /// POST /auth/login — authenticate with uid/email + password
  Future<LoginResponse> login(String uidEmail, String password) async {
    final data = await post('/auth/login', data: {
      'uid_email': uidEmail,
      'pw': password,
    });
    return LoginResponse.fromJson(data);
  }

  /// POST /auth/register — register new account
  Future<void> register({
    required String email,
    required String verificationCode,
    required String password,
    required String confirmPassword,
  }) async {
    await post('/auth/register', data: {
      'email': email,
      'register_verification_code': verificationCode,
      'pw': password,
      'confirm_pw': confirmPassword,
    });
  }

  /// POST /auth/register/verification-code — send register verification code to email
  Future<void> sendRegisterVerificationCode(String email) async {
    await post('/auth/register/verification-code', data: {'email': email});
  }

  /// POST /auth/password-reset/verification-code — send password reset code
  Future<void> sendPasswordResetVerificationCode(String email) async {
    await post('/auth/password-reset/verification-code', data: {'email': email});
  }

  /// POST /auth/password-reset — reset password with code
  Future<void> resetPassword({
    required String email,
    required String verificationCode,
    required String password,
    required String confirmPassword,
  }) async {
    await post('/auth/password-reset', data: {
      'email': email,
      'passwordreset_verification_code': verificationCode,
      'pw': password,
      'confirm_pw': confirmPassword,
    });
  }

  /// POST /auth/sign-in — daily sign-in
  Future<String> signIn() async {
    final data = await post('/auth/sign-in');
    return data['if_today_first_login'] as String;
  }
}
```

Note: All register/reset methods return `void`. The API returns `{"status": "success"}` on success; if error occurs, `_validate()` throws `ApiException`.

### 3.8 `lib/src/client.dart` — entry point

```dart
class OttohubClient {
  OttohubClient({String? baseUrl, Dio? dio, String? token}) {
    final d = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl ?? 'https://api.ottohub.cn/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    _dio = d;
    _token = token;
    auth = AuthApi(d, () => _token);
    // video = VideoApi(d, () => _token);  // future
  }

  late final Dio _dio;
  String? _token;

  late final AuthApi auth;
  // late final VideoApi video;

  String? get token => _token;
  set token(String? value) => _token = value;
}
```

- Optional `token` in constructor for convenience (equivalent to calling `client.token = '...'` after creation).
- No `_token` persistence or secure storage — consumer's responsibility.
- Timeouts set to 15 seconds (reasonable for mobile/API calls).

---

## 4. Implementation Order — Auth Module

| Step | Action | Expected output |
|------|--------|-----------------|
| **1** | `.gitignore` — remove `/pubspec.lock` line | Lockfile will be tracked |
| **2** | `pubspec.yaml` — replace with full content | Dependencies specified |
| **3** | `flutter pub get` (run in `ottohub_sdk_flutter/`) | All deps installed |
| **4** | Create `api_exception.dart` | Exception class ready |
| **5** | Create `base_api.dart` | Core HTTP abstraction |
| **6** | Create `login_response.dart` | Model with annotations |
| **7** | Run `dart run build_runner build --delete-conflicting-outputs` | `login_response.g.dart` generated |
| **8** | Create `auth_api.dart` | Auth methods |
| **9** | Create `client.dart` | Entry point |
| **10** | Update `ottohub_sdk_flutter.dart` barrel | Exports ready |
| **11** | Write model test `login_response_test.dart` | Tests pass |
| **12** | Write API test `auth_api_test.dart` | Tests pass |
| **13** | `flutter test` | All tests passing |
| **14** | `flutter analyze` | Zero warnings/errors |
| **15** | Verify `pubspec.lock` is tracked (`git status`) | Confirmation |

**Duration estimate**: ~2–3 hours for a developer familiar with the stack.

---

## 5. Testing

### 5.1 Model test (`test/src/models/auth/login_response_test.dart`)

Pure unit test — no Dio, no HTTP. Tests JSON deserialization.

Test cases:
1. Full response (all fields present) — verifies `uid` (String), `token`, nullable fields
2. Minimal response (only `uid` + `token`) — verifies null safety
3. Round-trip `toJson()` — verifies snake_case output

### 5.2 API test (`test/src/apis/auth_api_test.dart`)

Uses **mockito** (or manual Dio mock) to verify:
1. `login()` sends correct body (`uid_email`, `pw`) to the correct path
2. `login()` returns `LoginResponse` on success
3. Error response (`status: error`) throws `ApiException`
4. `register()`, `sendRegisterVerificationCode()`, etc. send correct parameters

If `mockito` is not already added, use a simple `FakeDio` class instead to avoid extra dependency:
```dart
class FakeDio extends Mock implements Dio {}
```

But this requires `mockito` + `build_runner` for codegen. Alternative: **manual mock**:
```dart
class _MockDio implements Dio {
  final List<_RequestExpectation> expectations = [];
  // ... implement only needed methods
}
```

We'll evaluate at test-writing time whether to add `mockito` or keep it manual.

### 5.3 Placeholder test

Keep `test/ottohub_sdk_flutter_test.dart` as-is (vanilla `Calculator` tests from scaffold) — not removed, just supplemented.

---

## 6. Error Handling

### 6.1 API errors

| Scenario | Mechanism | Consumer sees |
|----------|-----------|---------------|
| HTTP 4xx/5xx | Dio throws `DioException` | `DioException` (can catch separately) |
| API returns `{"status":"error","message":"..."}` | `_validate()` throws `ApiException` | `ApiException(message)` |
| Malformed response | `_validate()` throws `ApiException` | `ApiException('unexpected_response_format')` |

### 6.2 Token expiration

Not handled in SDK. When the API returns `error_token`, the consumer should:
```dart
try {
  await client.auth.login(email, pw);
} on ApiException catch (e) {
  if (e.errorCode == 'error_token') {
    // redirect to login screen
  }
}
```

---

## 7. Future Modules — Expansion Pattern

Once Auth module is complete, adding new API domains follows this pattern:

```
1. docs/video_api.md → read endpoint specs
2. src/models/video/video_detail.dart → @JsonSerializable model
3. dart run build_runner build → video_detail.g.dart
4. src/apis/video_api.dart → class VideoApi extends BaseApi
5. src/client.dart → late final VideoApi video;
6. lib/ottohub_sdk_flutter.dart → export models if needed
7. Tests → model test + API test
8. flutter test + flutter analyze → verify
```

Modules in order:
1. **Auth** (Phase 1) — login, register, sign-in
2. **Video** — list, detail, categories
3. **Following** — follow/unfollow, status, list, timeline, fans
4. **Block** — block/unblock, list
5. **Danmaku** — send, list
6. **Channel** — list
7. **Moderation** — content moderation

---

## 8. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| API shape changes | Model deserialization breaks | Pin API contract via `docs/`; verify before release |
| `uid` type inconsistency | Runtime cast error | Use `String` (verified); `JsonConverter` if needed later |
| `pubspec.lock` conflict after reinstating `.gitignore` | Version drift | Remove `.gitignore` entry before `git add .` last time before publishing |
| Dio v6 release | Breaking changes | Pin `^5.10.0`; upgrade deliberately |

---

## 9. Checklist — Auth Module Completion

- [ ] `.gitignore` updated (remove `/pubspec.lock`)
- [ ] `pubspec.yaml` updated + `flutter pub get`
- [ ] `src/exceptions/api_exception.dart` created
- [ ] `src/base_api.dart` created
- [ ] `src/models/auth/login_response.dart` created
- [ ] `login_response.g.dart` generated (build_runner)
- [ ] `src/apis/auth_api.dart` created
- [ ] `src/client.dart` created
- [ ] `lib/ottohub_sdk_flutter.dart` updated
- [ ] Model tests written and passing
- [ ] API tests written and passing
- [ ] `flutter test` — all pass
- [ ] `flutter analyze` — zero warnings
- [ ] `git status` shows `pubspec.lock` tracked
