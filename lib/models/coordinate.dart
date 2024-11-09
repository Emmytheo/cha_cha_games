class Coordinate {
  late int row;
  late int col;

  Coordinate({this.row = 0, this.col = 0});

  // Copy constructor with optional addition of row/col values
  Coordinate.of(Coordinate coor, {int addRow = 0, int addCol = 0}) {
    row = coor.row + addRow;
    col = coor.col + addCol;
  }

  // Ensure toString() is overridden for easy debugging
  @override
  String toString() {
    return 'Coordinate(row: $row, col: $col)';
  }

  // Check if two coordinates are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coordinate && other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
