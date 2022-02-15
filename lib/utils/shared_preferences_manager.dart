import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  Future<SharedPreferences> getSPInstance() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return session;
  }

  void addStringToCurrentSession(String key, String content) async {
    SharedPreferences session = await getSPInstance();
    session.setString(key, content);
  }

  Future<String> getStringFromKeyInCurrentSession(String key) async {
    SharedPreferences session = await getSPInstance();
    key = session.getString(key).toString();
    return key;
  }

  void emptyStringFromCurrentSession(String key) async {
    SharedPreferences session = await getSPInstance();
    session.setString(key, '');
  }

}