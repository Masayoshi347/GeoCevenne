import 'package:http/http.dart';
import 'dart:convert';

class PhpMyAdminHelper {

  void addUserToDatabase(String email, String password) async {
    var url = Uri.parse('http://ctrapp2013.free.fr/appmpr/insert_user_data.php');
    Response response = await post(url, body : {
      "email": email, "mdp": password
    });
  }

  Future<int> checkLoginInfoExistsInDatabase(String urlToCheck) async {
    Uri url = Uri.parse(urlToCheck);
    Response response = await get(url);
    int numberOfRowsWithTheseCredentials = int.parse(jsonDecode(response.body));
    return numberOfRowsWithTheseCredentials;
  }

}