# Basic Usage

This guide will walk you through creating a simple PlutoGrid Plus implementation.

## Creating a Basic Grid

Here's a complete example of a basic PlutoGrid Plus implementation:

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
      title: 'PlutoGrid Basic Example',
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
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    
    // Define columns
    columns.addAll([
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 200,
      ),
      PlutoColumn(
        title: 'Age',
        field: 'age',
        type: PlutoColumnType.number(),
        width: 100,
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
        type: PlutoColumnType.select(['Developer', 'Designer', 'Manager']),
        width: 150,
      ),
    ]);
    
    // Create rows
    rows.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlutoGrid Basic Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print('Cell changed: ${event.value}');
          },
        ),
      ),
    );
  }
}
```

## Key Components

### 1. Columns

Columns define the structure of your grid. Each column needs:

- `title`: The text displayed in the column header
- `field`: A unique identifier for the column
- `type`: The data type (text, number, select, date, time, etc.)
- `width`: The width of the column (optional, but recommended)

```dart
PlutoColumn(
  title: 'Name',
  field: 'name',
  type: PlutoColumnType.text(),
  width: 200,
)
```

### 2. Rows

Rows contain the data displayed in the grid. Each row consists of cells that correspond to the columns:

```dart
PlutoRow(
  cells: {
    'id': PlutoCell(value: '1'),
    'name': PlutoCell(value: 'John Doe'),
    'age': PlutoCell(value: 28),
    'role': PlutoCell(value: 'Developer'),
  },
)
```

### 3. StateManager

The `PlutoGridStateManager` provides methods to control the grid programmatically:

```dart
late PlutoGridStateManager stateManager;

// In your onLoaded callback:
onLoaded: (PlutoGridOnLoadedEvent event) {
  stateManager = event.stateManager;
},
```

## Column Types

PlutoGrid Plus supports various column types:

### Text

```dart
PlutoColumn(
  title: 'Name',
  field: 'name',
  type: PlutoColumnType.text(),
)
```

### Number

```dart
PlutoColumn(
  title: 'Age',
  field: 'age',
  type: PlutoColumnType.number(),
)
```

### Select

```dart
PlutoColumn(
  title: 'Role',
  field: 'role',
  type: PlutoColumnType.select(['Developer', 'Designer', 'Manager']),
)
```

### Date

```dart
PlutoColumn(
  title: 'Birth Date',
  field: 'birth_date',
  type: PlutoColumnType.date(),
)
```

### Time

```dart
PlutoColumn(
  title: 'Start Time',
  field: 'start_time',
  type: PlutoColumnType.time(),
)
```

### Currency

```dart
PlutoColumn(
  title: 'Salary',
  field: 'salary',
  type: PlutoColumnType.currency(
    symbol: '\$',
    decimalDigits: 2,
  ),
)
```

## Event Handling

### onLoaded

Called when the grid is first loaded:

```dart
onLoaded: (PlutoGridOnLoadedEvent event) {
  stateManager = event.stateManager;
},
```

### onChanged

Called when a cell value is changed:

```dart
onChanged: (PlutoGridOnChangedEvent event) {
  print('Cell changed: ${event.value}');
},
```

### Other Events

PlutoGrid Plus provides many other events for specific interactions:

- `onSelected`: Called when a cell or row is selected
- `onRowChecked`: Called when a row checkbox is toggled
- `onSorted`: Called when columns are sorted
- `onRowsMoved`: Called when rows are moved

## Next Steps

Now that you understand the basics, explore more advanced features:

- [Column Configuration](../features/column-types.md)
- [Row Operations](../features/row-selection.md)
- [Cell Customization](../features/cell-renderer.md)
- [Styling and Theming](../features/themes.md)
