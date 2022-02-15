import 'dart:ui';

import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/constants/strings.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/loading_screen.dart';
import 'package:ctr2013app/utils/navigation_manager.dart';
import 'package:ctr2013app/utils/phpmyadmin_helper.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:ctr2013app/widgets/field_widget.dart';
import 'package:ctr2013app/widgets/popup_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = "";
  String password = "";
  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget loginLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Strings.mainTitle, style: TextStyle(fontSize: 30, color: Colors.white)),
          loginForm(),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: formKey,
      child: loginFields(),
    );
  }

  Widget loginFields() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Fields().simpleField(Strings.emailLabel, false, setNewEmail),
          Fields().simpleField(Strings.passwordLabel, true, setNewPassword),
          SizedBox(height: 50,),
          validationButtonWrapper(Strings.loginButton, 'login', 250),
          validationButtonWrapper(Strings.registerButton, 'register', 250),
          validationButtonWrapper(Strings.offlineMode, 'offline', 250),
        ],
      ),
    );
  }

  void setNewEmail(String value) {
    setState(() {
      email = value.toString();
    });
  }

  void setNewPassword(String value) {
    setState(() {
      password = value.toString();
    });
  }

  Widget validationButtonWrapper(String label, processToExecute, double size) {
    return SizedBox(
      width: size,
      child: validationButton(label, processToExecute),
    );
  }

  Widget validationButton(String label, processToExecute) {
    return ElevatedButton(
        onPressed: () {validateFormFields(processToExecute);},
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber[900],
        ),
    );
  }

  void validateFormFields(String pickedProcess) {
    if(pickedProcess != "offline") {
      if(formKey.currentState.validate()) {
        pickProcess(pickedProcess);
      }
    } else {
      startOfflineProcess();
    }
  }

  void pickProcess(String pickedProcess) {
    switch(pickedProcess) {
      case "login" : {startLoggingProcess();} break;
      case "register" : {startRegistrationProcess();} break;
    }
  }

  void startLoggingProcess() async {
    changeLoadingStatus();
    int numberOfRowsWithTheseCredentials = await PhpMyAdminHelper().checkLoginInfoExistsInDatabase('http://ctrapp2013.free.fr/appmpr/login.php?email=$email&mdp=$password');
    isLoginCorrect(numberOfRowsWithTheseCredentials);
  }

  changeLoadingStatus() {
    setState(() {
      loading = !loading;
    });
  }

  void isLoginCorrect(int numberOfRowsWithTheseCredentials) async {
    if(numberOfRowsWithTheseCredentials == 1) {
      endLoggingProcess();
    } else {
      changeLoadingStatus();
      Popups().showBasicPopup(context, Strings.cantConnectMessage, Strings.noAccountForTheseCredentials);
    }
  }

  void endLoggingProcess() {
    SharedPreferencesManager().addStringToCurrentSession('email', email);
    NavigationManager().changeScreen(context, HomeScreen());
  }

  void startRegistrationProcess() async {
    changeLoadingStatus();
    int numberOfRowsWithTheseCredentials = await PhpMyAdminHelper().checkLoginInfoExistsInDatabase('http://ctrapp2013.free.fr/appmpr/register_check.php?email=$email');
    isUserAlreadyRegistered(numberOfRowsWithTheseCredentials);
  }

  void isUserAlreadyRegistered(int numberOfRowsWithTheseCredentials) {
    if(numberOfRowsWithTheseCredentials == 1) {
      changeLoadingStatus();
      Popups().showBasicPopup(context, Strings.operationUnavailable, Strings.emailAlreadyInUse);
    } else {
      endRegistrationProcess();
    }
  }

  void endRegistrationProcess() {
    PhpMyAdminHelper().addUserToDatabase(email, password);
    endLoggingProcess();
  }

  void startOfflineProcess() {
    Popups().showMultipleActionPopup(context, Strings.offlineMode, Strings.offlineModeDesc, [offlineModeContinue(), Buttons().popButton(context)]);
  }

  Widget offlineModeContinue() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: endOfflineProcess,
          child: Text(Strings.continueMessage),
          style: ElevatedButton.styleFrom(
            primary: Colors.amber[900],
          ),
      ),
    );
  }

  void endOfflineProcess() {
    SharedPreferencesManager().addStringToCurrentSession('email', 'offline');
    NavigationManager().changeScreen(context, HomeScreen());
  }

  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.amber[200],
      body: Container(
          child: BackdropFilter(
              child: BackButtonManager().handleBackButton(loginLayout()),
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_screen.jpg"),
              fit: BoxFit.cover,
            )
          ),
      )
    );
  }
}



