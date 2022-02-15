import 'package:ctr2013app/constants/strings.dart';
import 'package:flutter/material.dart';

class Fields {

  Widget simpleField(String label, bool isTextObscured, newValueFunction) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: checkFieldEmpty,
      onChanged: newValueFunction,
      obscureText: isTextObscured,
    );
  }

  String checkFieldEmpty(String value) {
    if(value == null || value.isEmpty) {
      return Strings.requiredMessage;
    } else {
      return null;
    }
  }

}