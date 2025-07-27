class UserPreferences {
  static const String userGenderKey = 'user_gender';
  static const String targetGenderKey = 'target_gender';

  static const String male = 'male';
  static const String female = 'female';

  static String getTargetGender(String userGender) {
    return userGender == male ? female : male;
  }

  static String getInterfaceTheme(String userGender) {
    // Men see female-themed interface, women see male-themed interface
    return getTargetGender(userGender);
  }
}
