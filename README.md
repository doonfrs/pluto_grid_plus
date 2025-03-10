# PlutoGrid Plus for flutter - v8.4.10

Please star ⭐⭐⭐⭐⭐ the repo if you find this package useful.

`PlutoGrid` is a `DataGrid` that can be operated with the keyboard in various situations such as moving cells.  
It is developed with priority on the web and desktop.  
Improvements such as UI on mobile are being considered.  
If you comment on an issue, mobile improvements can be made quickly.

## [Demo Web](https://doonfrs.github.io/pluto_grid_plus)
>
> You can try out various functions and usage methods right away.  
> All features provide example code.

## [Pub.Dev](https://pub.dev/packages/pluto_grid_plus)
>
> Check out how to install from the official distribution site.

## [ChangeLog](https://github.com/doonfrs/pluto_grid_plus/blob/master/CHANGELOG.md)
>
> Please note the changes when changing the version of PlutoGrid you are using.

## [Issue](https://github.com/doonfrs/pluto_grid_plus/issues)
>
> Report any questions or errors.

## Packages

> [PlutoGridExport](https://github.com/doonfrs/pluto_grid_plus/tree/master/packages/pluto_grid_plus_export)  
> This package can export the metadata of PlutoGrid as CSV or PDF.

## Screenshots

### Change the color of the rows or make the cells look the way you want them

![PlutoGrid Normal](https://bosskmk.github.io/images/pluto_grid/2.8.0/pluto_grid_2.8.0_01.png)

### Date type input can be easily selected by pop-up and keyboard

![PlutoGrid Select Popup](https://bosskmk.github.io/images/pluto_grid/3.1.0/pluto_grid_3.1.0_01.png)

### The selection type column can be easily selected using a pop-up and keyboard

![PlutoGrid Select Date](https://bosskmk.github.io/images/pluto_grid/2.8.0/pluto_grid_2.8.0_03.png)

### Group columns by desired depth

![PlutoGrid Cell renderer](https://bosskmk.github.io/images/pluto_grid/2.8.0/pluto_grid_2.8.0_04.png)

### Grid can be expressed in dark mode or a combination of desired colors. Also, freeze the column, move it by dragging, or adjust the size

![PlutoGrid Multi select](https://bosskmk.github.io/images/pluto_grid/2.8.0/pluto_grid_2.8.0_05.png)

## Example

Generate the data to be used in the grid.

```dart

List<PlutoColumn> columns = [
  /// Text Column definition
  PlutoColumn(
    title: 'text column',
    field: 'text_field',
    type: PlutoColumnType.text(),
  ),
  /// Number Column definition
  PlutoColumn(
    title: 'number column',
    field: 'number_field',
    type: PlutoColumnType.number(),
  ),
  /// Select Column definition
  PlutoColumn(
    title: 'select column',
    field: 'select_field',
    type: PlutoColumnType.select(['item1', 'item2', 'item3']),
  ),
  /// Datetime Column definition
  PlutoColumn(
    title: 'date column',
    field: 'date_field',
    type: PlutoColumnType.date(),
  ),
  /// Time Column definition
  PlutoColumn(
    title: 'time column',
    field: 'time_field',
    type: PlutoColumnType.time(),
  ),
];

List<PlutoRow> rows = [
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value1'),
      'number_field': PlutoCell(value: 2020),
      'select_field': PlutoCell(value: 'item1'),
      'date_field': PlutoCell(value: '2020-08-06'),
      'time_field': PlutoCell(value: '12:30'),
    },
  ),
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value2'),
      'number_field': PlutoCell(value: 2021),
      'select_field': PlutoCell(value: 'item2'),
      'date_field': PlutoCell(value: '2020-08-07'),
      'time_field': PlutoCell(value: '18:45'),
    },
  ),
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value3'),
      'number_field': PlutoCell(value: 2022),
      'select_field': PlutoCell(value: 'item3'),
      'date_field': PlutoCell(value: '2020-08-08'),
      'time_field': PlutoCell(value: '23:59'),
    },
  ),
];
```

Create a grid with the data created above.

```dart
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('PlutoGrid Demo'),
    ),
    body: Container(
      padding: const EdgeInsets.all(30),
      child: PlutoGrid(
          columns: columns,
          rows: rows,
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            print(event);
          }
      ),
    ),
  );
}
```

PlutoGrid Plus is a maintained & improved version of PlutoGrid as the original is no longer active.
