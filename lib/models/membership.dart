enum Membership {
  Bronze,
  Silver,
  Gold,
  Diamond,
}

Membership parseMembershipFromString(String value) {
  if (value == 'Bronze') {
    return Membership.Bronze;
  } else if (value == 'Silver') {
    return Membership.Silver;
  } else if (value == 'Gold') {
    return Membership.Gold;
  } else {
    return Membership.Diamond;
  }
}

extension ParseToString on Membership {
  String valueString() {
    if (this == Membership.Bronze) {
      return 'Bronze';
    } else if (this == Membership.Silver) {
      return 'Silver';
    } else if (this == Membership.Gold) {
      return 'Gold';
    } else {
      return 'Diamond';
    }
  }
}
