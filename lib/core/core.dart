

class Core {

  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  var appVersion = '2.0.2';

  var language = 'en';
}