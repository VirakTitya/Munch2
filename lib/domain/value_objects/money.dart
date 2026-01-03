class Money {
  final double value;

  Money(this.value) {
    if (value < 0) {
      throw ArgumentError('Money cannot be negative');
    }
  }
}
