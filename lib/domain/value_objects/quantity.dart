class Quantity {
  final int value;

  Quantity(this.value) {
    if (value <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }
  }
}
