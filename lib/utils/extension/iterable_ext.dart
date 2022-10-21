extension IterableExt<E> on Iterable<E> {
  Iterable shift(int number) {
    if (number <= 0) {
      return this;
    }

    final sub = length - number;
    return Iterable<dynamic>.generate(length, (index) {
      if (sub + index < length) {
        return elementAt(sub + index);
      } else {
        return elementAt(index - number);
      }
    });
  }

  E? tryFirstWhere(bool Function(E element) test, {E Function()? orElse}) {
    try {
      return firstWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }

  E? tryFirst() {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }
}

extension ListExt<E> on List<E> {
  List<E> asCopy() {
    return List<E>.from(this);
  }
}

extension MapExt<K, V> on Map<K, V> {
  Map<K, V> asCopy() {
    return Map<K, V>.from(this);
  }
}
