# Cell Renderer

The cell renderer feature allows you to customize the appearance of individual cells in PlutoGrid Plus. This is particularly useful when you want to:

- Display cell values with custom formatting
- Add icons or other visual indicators based on cell values
- Create interactive elements within cells
- Apply conditional styling based on cell content

## Overview

PlutoGrid Plus provides two levels of rendering customization:

1. **Column-level rendering**: Apply a custom renderer to all cells in a column
2. **Cell-level rendering**: Apply a custom renderer to specific individual cells

When both are defined, the cell-level renderer takes precedence over the column-level renderer.

## Cell-Level Renderer

### Basic Usage

To apply a custom renderer to a specific cell, provide a `renderer` function when creating the `PlutoCell`:

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

### The PlutoCellRendererContext

The renderer function receives a `PlutoCellRendererContext` object that provides access to:

- `column`: The column definition
- `rowIdx`: The row index
- `row`: The row data
- `cell`: The cell being rendered
- `stateManager`: The grid's state manager

This context allows you to create dynamic renderers that respond to the cell's data and position within the grid.

## Examples

### Status Indicator

Create a status indicator with different colors based on the cell value:

```dart
PlutoCell(
  value: 'In Progress',
  renderer: (rendererContext) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (rendererContext.cell.value) {
      case 'Completed':
        backgroundColor = Colors.green;
        break;
      case 'In Progress':
        backgroundColor = Colors.orange;
        break;
      case 'Pending':
        backgroundColor = Colors.blue;
        break;
      case 'Cancelled':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rendererContext.cell.value.toString(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  },
)
```

### Icon with Text

Display an icon alongside text based on the cell value:

```dart
PlutoCell(
  value: 'High',
  renderer: (rendererContext) {
    IconData iconData;
    Color iconColor;

    switch (rendererContext.cell.value) {
      case 'Low':
        iconData = Icons.arrow_downward;
        iconColor = Colors.green;
        break;
      case 'Medium':
        iconData = Icons.arrow_forward;
        iconColor = Colors.blue;
        break;
      case 'High':
        iconData = Icons.arrow_upward;
        iconColor = Colors.orange;
        break;
      case 'Critical':
        iconData = Icons.priority_high;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  },
)
```

### Interactive Elements

Create cells with interactive elements:

```dart
PlutoCell(
  value: 5,
  renderer: (rendererContext) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            // Decrement the value
            int currentValue = rendererContext.cell.value;
            if (currentValue > 0) {
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                currentValue - 1,
              );
            }
          },
          iconSize: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(rendererContext.cell.value.toString()),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            // Increment the value
            int currentValue = rendererContext.cell.value;
            rendererContext.stateManager.changeCellValue(
              rendererContext.cell,
              currentValue + 1,
            );
          },
          iconSize: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  },
)
```

### Conditional Formatting

Apply different styles based on cell value:

```dart
PlutoCell(
  value: 85,
  renderer: (rendererContext) {
    int value = rendererContext.cell.value;
    Color textColor;
    
    if (value >= 90) {
      textColor = Colors.green;
    } else if (value >= 70) {
      textColor = Colors.blue;
    } else if (value >= 50) {
      textColor = Colors.orange;
    } else {
      textColor = Colors.red;
    }
    
    return Text(
      '$value%',
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  },
)
```

## Best Practices

1. **Performance**: Keep your renderer functions efficient to maintain smooth scrolling
2. **Reusability**: Create reusable renderer functions for common patterns
3. **Responsiveness**: Make your custom widgets adapt to different cell sizes
4. **Consistency**: Maintain a consistent look and feel across your grid
5. **Accessibility**: Ensure your custom renderers maintain accessibility features

## Comparison with Column Renderer

While column renderers apply to all cells in a column, cell renderers allow for more granular control:

```dart
// Column-level renderer (applies to all cells in the column)
PlutoColumn(
  title: 'Status',
  field: 'status',
  type: PlutoColumnType.text(),
  renderer: (rendererContext) {
    // Default rendering for all cells in this column
    return Text(
      rendererContext.cell.value.toString(),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  },
)

// Cell-level renderer (applies only to this specific cell)
PlutoCell(
  value: 'Completed',
  renderer: (rendererContext) {
    // Custom rendering for this specific cell
    return Container(
      color: Colors.green,
      child: Text(rendererContext.cell.value.toString()),
    );
  },
)
```

## Related Features

- [Column Renderer](column-renderer.md): Apply custom renderers to all cells in a column
- [Cell Editing](cell-editing.md): Customize the cell editing experience
- [Custom Styling](custom-styling.md): Apply global styling to your grid
