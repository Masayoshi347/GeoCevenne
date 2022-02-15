import 'package:ctr2013app/utils/shared_preferences_manager.dart';

class OfflineChecker {

  bool offline = false;

  Future<bool> checkIfUserIsOffline() async {
    String checkedEmail = await SharedPreferencesManager().getStringFromKeyInCurrentSession('email');
    checkedEmail == "offline" ? offline = true : offline = false;
    return offline;
  }

}