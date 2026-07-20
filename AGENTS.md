# AGENTS.md — ottohub_sdk

Pure Dart package (no Flutter dependency) at `ottohub_sdk_dart/` (v0.0.1), wrapping OTTOhub HTTP APIs with Dio + json_serializable. Compatible with both Dart and Flutter projects.

## Commands (run from `ottohub_sdk_dart/`)

```bash
flutter pub get                                # install deps
flutter test                                   # all 177 tests (unit + integration)
flutter test test/src/apis/video_api_test.dart  # single test file
flutter analyze                                # lint + static analysis (must pass)
dart format .                                  # format all Dart code
dart run build_runner build                    # regenerate .g.dart files (pre-committed)
```

CI pipeline order: `analyze` → `test` → `format check`.

## Architecture

```
OttohubClient → I*Api interfaces → BaseApi (abstract) → Dio
```

All public types are abstract interfaces (`IVideoApi`). Concrete implementations (`VideoApi`) `implements` the interface in the same file. `OttohubClient` fields are typed as interfaces for testability.

## Barrel export quirk

`lib/ottohub_sdk_dart.dart` uses `show` to export only interfaces + client + models. Two files bundle two modules each:

- `old_profile_api.dart` → `IOldProfileApi, IOldCreatorApi`
- `old_system_api.dart` → `IOldSystemApi, IOldCollectionApi`

When adding a new API module or model, add a new export line to this file.

## Testing

- **Unit tests**: `mocktail` — mock `Dio` directly, instantiate concrete API classes.
- **Integration tests**: `test/integration/api_integration_test.dart` — 6 tests hitting real `/api/video/*` endpoints (requires network).
- `.g.dart` files and `pubspec.lock` are committed (no need to regenerate for tests).
- `use_null_aware_elements` info-level lints are expected (pre-existing, not actionable).

## Real API server quirks

- **Numeric fields as strings**: Old-API-style endpoints (`/video/random`, `/video/new`, `/video/popular`, `/video/search`) return numbers as strings (`"vid": "22257"`). `StringToIntConverter` / `StringToNullableIntConverter` in `models/utils/converters.dart` handle both `String` and `num`.
- **`VideoDetail.lastWatchSecond`**: Only returned when `token` is provided; type is `int?`.
- **`/api/system/*` endpoints**: Return 404 — not deployed. Old API module is implemented but cannot be E2E-tested.
- **Category values**: Numeric strings (`"0"`, `"1"`, `"2"`), not English names.
- **HTTP-level errors bypass `ApiException`**: Dio's default `validateStatus` throws `DioException` for 4xx/5xx. `BaseApi._validate` only catches JSON-level `status: "error"`. Catch both `ApiException` and `DioException`.
- **`ChannelDetail.channelId` (video sub-model)**: Server may return empty string `""`; handled by custom `_asString` getter.
- **Token injection rule**: GET/DELETE → queryParameters; POST/PUT → body data; POST+FormData → form field.

## Conventions

- API field names and error codes use `snake_case` (`uid_email`, `error_token`).
- Common error codes: `missing_argument`, `error_token`, `system_error`, `too_many_requests`.
- Dartdoc is in Chinese (matching README).

