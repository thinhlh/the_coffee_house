enum Membership {
  Bronze,
  Silver,
  Gold,
  Diamond,
}

extension ParseToString on Membership {
  String valueString() {
    return this.toString().split('.').last;
  }
}
