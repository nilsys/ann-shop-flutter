final double defaultPadding = 15;
const int itemPerPage = 20;

class Core {
  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    /// init
  }

  static const appVersion = '1.0.0';

  static const domain = 'http://xuongann.com/';
}
