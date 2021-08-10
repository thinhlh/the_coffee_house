enum OrderMethod {
  Delivery,
  TakeAway,
}

extension ToValueString on OrderMethod {
  String get valueString =>
      this == OrderMethod.Delivery ? 'Delivery' : 'TakeAway';
}
