import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;

  // Use a factory constructor to ensure a single instance of SharedPref
  factory SharedPref() {
    if (_instance == null) {
      _instance = SharedPref._();
    }
    return _instance!;
  }

  SharedPref._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> savePrivateKey(String private_key) async {
    await _prefs.setString('privateKey', private_key);
  }

  Future<String?> getPrivateKey() async {
    return _prefs.getString('privateKey');
  }

  Future<void> removeData() async {
    await _prefs.remove('privateKey');
  }
}
