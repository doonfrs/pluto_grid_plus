# PlutoGrid Plus

[![Pub Version](https://img.shields.io/pub/v/pluto_grid_plus.svg)](https://pub.dev/packages/pluto_grid_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> ⭐ **Please star this repository to support the project!** ⭐
>

PlutoGrid Plus is a powerful data grid for Flutter that provides a wide range of features for displaying, editing, and managing tabular data. It works seamlessly on all platforms including web, desktop, and mobile.

![PlutoGrid Plus Demo](https://raw.githubusercontent.com/doonfrs/pluto_grid_plus/master/screenshots/pluto_grid_plus_demo.gif)

> PlutoGrid Plus is a maintained and enhanced version of the original PlutoGrid package. I'm [Feras Abdulrahman](https://github.com/doonfrs), the current maintainer, and I'm actively working on adding new features and keeping this great package rich and up-to-date. I continued the development after the original package [PlutoGrid](https://github.com/bosskmk/pluto_grid) was no longer being maintained.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  pluto_grid_plus: ^8.4.13
```

Then run:

```bash
flutter pub get
```

## Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlutoGrid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<PlutoColumn> columns = [
    PlutoColumn(
      title: 'ID',
      field: 'id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Role',
      field: 'role',
      type: PlutoColumnType.select(['Developer', 'Designer', 'Manager']),
    ),
  ];

  final List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'id': PlutoCell(value: '1'),
        'name': PlutoCell(value: 'John Doe'),
        'age': PlutoCell(value: 28),
        'role': PlutoCell(value: 'Developer'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: '2'),
        'name': PlutoCell(value: 'Jane Smith'),
        'age': PlutoCell(value: 32),
        'role': PlutoCell(value: 'Designer'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: '3'),
        'name': PlutoCell(value: 'Mike Johnson'),
        'age': PlutoCell(value: 45),
        'role': PlutoCell(value: 'Manager'),
      },
    ),
  ];

  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlutoGrid Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
          },
        ),
      ),
    );
  }
}
```

## Features

PlutoGrid Plus offers a comprehensive set of features for handling tabular data:

### Column Features

- **Column Types**: Support for various data types (text, number, select, date, time, currency)
- **Column Freezing**: Freeze columns to the left or right
- **Column Resizing**: Adjust column width by dragging
- **Column Moving**: Change column order by drag and drop
- **Column Hiding**: Hide and show columns as needed
- **Column Sorting**: Sort data by clicking on column headers
- **Column Filtering**: Filter data with built-in filter widgets
- **Column Groups**: Group related columns together
- **Column Renderers**: Customize column appearance with custom widgets
- **Column Footer**: Display aggregate values at the bottom of columns

### Row Features

- **Row Selection**: Select single or multiple rows
- **Row Moving**: Reorder rows by drag and drop
- **Row Coloring**: Apply custom colors to rows
- **Row Checking**: Built-in checkbox selection for rows
- **Row Groups**: Group related rows together
- **Frozen Rows**: Keep specific rows visible while scrolling

### Cell Features

- **Cell Selection**: Select individual cells or ranges
- **Cell Editing**: Edit cell values with appropriate editors
- **Cell Renderers**: Customize individual cell appearance
- **Cell Validation**: Validate cell values during editing

### Data Management

- **Pagination**: Built-in pagination support
- **Infinite Scrolling**: Load data as the user scrolls
- **Lazy Loading**: Load data on demand
- **Copy & Paste**: Copy and paste data between cells
- **Export**: Export data to CSV format (with pluto_grid_plus_export package)

### UI Customization

- **Themes**: Light and dark mode support
- **Custom Styling**: Customize colors, borders, and text styles
- **RTL Support**: Right-to-left language support
- **Responsive Design**: Works on all screen sizes

### Other Features

- **Keyboard Navigation**: Navigate and edit using keyboard shortcuts
- **Context Menus**: Right-click menus for columns and cells
- **Dual Grid Mode**: Display two linked grids side by side
- **Popup Mode**: Use the grid as a popup selector

## New Feature: Cell-Level Renderers

PlutoGrid Plus now supports cell-level renderers, allowing you to customize the appearance of individual cells:

```dart
PlutoCell(
  value: 'Completed',
  renderer: (rendererContext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rendererContext.cell.value.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  },
)
```

This powerful feature enables:

- Custom formatting for specific cells
- Visual indicators based on cell values
- Interactive elements within cells
- Conditional styling for individual cells

Cell renderers take precedence over column renderers, giving you fine-grained control over your grid's appearance.

## Documentation

For detailed documentation on each feature, please visit our [Wiki](https://github.com/doonfrs/pluto_grid_plus/wiki) or check the `/docs` folder in the repository.

## Examples

Check out the [example project](https://github.com/doonfrs/pluto_grid_plus/tree/master/example) for more usage examples.

You can also try the [live demo](https://pluto.weblaze.dev/) to see PlutoGrid Plus in action.

## Contributing

Contributions are welcome! If you'd like to help improve PlutoGrid Plus, here's how you can contribute:

- **Star the repository** ⭐ to show your support
- **Report bugs** by opening issues
- **Suggest new features** or improvements
- **Submit pull requests** to fix issues or add functionality
- **Improve documentation** to help other users
- **Share the package** with others who might find it useful

I'm committed to maintaining and improving this package, and your contributions help make it better for everyone. Feel free to reach out if you have any questions or ideas!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
