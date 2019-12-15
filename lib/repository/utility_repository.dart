
class UtilityRepository {
  static final UtilityRepository instance = UtilityRepository._internal();

  factory UtilityRepository() => instance;

  UtilityRepository._internal() {
    /// init
  }

  log(object) {
    print('utility_repository: ' + object.toString());
  }
}
