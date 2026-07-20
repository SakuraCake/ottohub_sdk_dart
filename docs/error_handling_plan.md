# 错误处理增强 + 最大兼容模式 — 实施方案

## 设计原则

1. **严格模式（默认）= 零性能开销**：代码路径与现在完全相同，不加任何额外检查/分支
2. **兼容模式 = 按需启用**：每个维度独立开关，用户只开需要的
3. **配置集中在 `BaseApi` + 转换器层**，不污染每个 `fromJson` 调用

## 文件结构

```
lib/src/exceptions/
├── api_exception.dart        # 加 httpStatus, responseData, innerException
└── api_error_codes.dart      # 新增：错误码常量（按模块分组）

lib/src/base_api.dart         # 加配置参数 + _validate 增强 + DioException 包装

lib/src/client.dart           # 透传配置参数给所有 API 模块

lib/ottohub_sdk_dart.dart     # 导出 api_error_codes.dart
```

## 实现步骤

### 1. 增强 `ApiException`

新增可选字段，不改变现有构造用法：

```dart
class ApiException implements Exception {
  final String errorCode;
  final int? httpStatus;
  final Map<String, dynamic>? responseData;
  final Exception? innerException;

  const ApiException(this.errorCode, {
    this.httpStatus,
    this.responseData,
    this.innerException,
  });
}
```

### 2. 新增错误码常量

`api_error_codes.dart` 按模块分组（Auth, Video, Following, Block, Danmaku, Moderation, 通用）。
使用 `abstract final class` + `static const`，编译期内联，零运行时开销。

### 3. `BaseApi` 配置化

新增三个独立布尔参数：

| 参数 | 默认值 | 作用 |
|------|--------|------|
| `wrapHttpErrors` | `false` | DioException → ApiException 包装 |
| `relaxedResponse` | `false` | 响应结构容错（非 Map、无 status 键） |
| `relaxedTypes` | `false` | 类型自动转换（List/Map 安全过滤） |

`_validate()` 增强：严格模式路径不变，`!relaxedResponse` 守卫是 O(1) 布尔检查。

### 4. HTTP 错误包装

每个 HTTP 方法外套 try-catch，仅在 `wrapHttpErrors=true` 时将 `DioException` 转为 `ApiException`。
try-catch 在未抛出时是 Dart VM 零开销的。

### 5. 转换器增强

`StringToIntConverter` 等已有宽松行为。`relaxedTypes` 在 `BaseApi` 层控制 `safeList`/`safeMap` 辅助方法。

### 6. API 实现类透传

17 个 API 类构造统一改为 `{super.wrapHttpErrors, super.relaxedResponse, super.relaxedTypes}`。

### 7. 测试

| 文件 | 测试内容 |
|------|---------|
| `test/src/exceptions/api_exception_test.dart` | 增强 ApiException |
| `test/src/exceptions/api_error_codes_test.dart` | 常量值 |
| `test/src/base_api_test.dart` | _validate 兼容模式、wrapHttpErrors |
| `test/complete_api_test.dart` | 扩展 Error handling group |
