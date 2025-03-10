# Installation

Adding PlutoGrid Plus to your Flutter project is straightforward. Follow these steps to get started:

## 1. Add Dependency

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  pluto_grid_plus: ^8.4.13
```

## 2. Install Package

Run the following command to install the package:

```bash
flutter pub get
```

## 3. Import Package

Import the package in your Dart code:

```dart
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
```

## 4. Optional Dependencies

### Export Functionality

If you need to export data from PlutoGrid Plus to CSV or other formats, add the export package:

```yaml
dependencies:
  pluto_grid_plus_export: ^1.0.0
```

## Platform-Specific Considerations

### Web

PlutoGrid Plus works well on the web platform without any additional configuration.

### Desktop (Windows, macOS, Linux)

PlutoGrid Plus is optimized for desktop platforms with keyboard navigation and shortcuts.

### Mobile (Android, iOS)

While PlutoGrid Plus works on mobile platforms, it's primarily designed for larger screens. Consider the following when using on mobile:

- Use appropriate column widths for smaller screens
- Consider using fewer columns for better usability
- Test scrolling and touch interactions thoroughly

## Compatibility

PlutoGrid Plus requires:

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher

## Troubleshooting

If you encounter any issues during installation:

1. Make sure you have the correct version specified in your pubspec.yaml
2. Run `flutter clean` followed by `flutter pub get`
3. Restart your IDE
4. Check for any conflicting dependencies

If problems persist, please [open an issue](https://github.com/doonfrs/pluto_grid_plus/issues) on GitHub.
