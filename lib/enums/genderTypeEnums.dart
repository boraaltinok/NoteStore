enum GenderType {
  male,
  female,
  intersex,
  preferNotToState
}

extension GenderTypeExtension on GenderType {

  int returnGenderTypeNumber() {
    switch (this) {
      case GenderType.male:
        return  0;
      case GenderType.female:
        return  1;
      case GenderType.intersex:
        return  2;
      case GenderType.preferNotToState:
        return  3;
    }
  }
}