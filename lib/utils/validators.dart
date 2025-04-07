// Flutter imports:
import 'package:flutter/services.dart';

class Validators {
  static String? validateName(String value, String type) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "$type is Required";
    } else if (!regExp.hasMatch(value)) {
      return "$type must be between a-z and A-Z";
    }
    return null;
  }

  static String? validateRequired(String? value, String type) {
    if (value?.length == 0) {
      return "$type is Required";
    }
    return null;
  }

  static String? validateDynamicRequired(String value, String type) {
    // String pattern = r'(^\s*$)';
    // RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "$type is Required";
    }
    return null;
  }

  static String? validatedByAlphaNumeric(String value, String type, {isRequired = true}) {
    String pattern = r'^[a-zA-Z0-9 ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0 && isRequired == true) {
      return "$type is Required";
    } else if (!regExp.hasMatch(value)) {
      return "$type must be alphanumeric";
    }
    return null;
  }

  String? validateMobile(String value) {
    String pattern = r'(^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4,5})$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Phone number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number is not valid (Minimum 10 digits)";
    }
    return null;
  }

  String? validatePinCode(String value) {
    String pattern = r'^[0-9]{1,6}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Phone number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number is not valid (Minimum 10 digits)";
    }
    return null;
  }

  //For Email Verification we using RegEx.
  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value == null || value.length <= 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    String pattern = r'^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Minimum 8 characters password required with a combination of uppercase and lowercase letter and number are required.";
    } else {
      return null;
    }
  }

  String? validatePass(String value) {
    if (value.isEmpty) {
      return 'Please enter Password';
    }
    if (value.length < 9) {
      return 'Must be more than 8 character';
    } else {
      return null;
    }
  }

  static String? validateBusinessMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String? validateEstablishedYear(String value) {
    var date = new DateTime.now();
    int currentYear = date.year;
    int userInputValue = 0;

    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    // int numValue = int.parse(value);
    if (!regExp.hasMatch(value)) {
      return "Year must be number only";
    } else if (value.length == 0) {
      return "Established Year is Required";
    } else {
      userInputValue = int.parse(value);
    }

    if (userInputValue < 1850 || userInputValue > currentYear) {
      return "Year must be between 1850 and $currentYear";
    }
    return null;
  }

  String? validateLicenseNo(String value) {
    if (value.length == 0) {
      return "License No is Required";
    }
    return null;
  }

  String? validateNumberOfEmployee(String value) {
    String pattern = r'(^[1-9]\d*(\.\d+)?$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Number of employee is Required";
    } else if (value.length > 4) {
      return "Number of employee is not more than 9999";
    } else if (!regExp.hasMatch(value)) {
      return "Number of employee must be digits";
    }
    return null;
  }

  String? validateDate(String value) {
    String pattern = r'([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Date is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid date";
    }
    return null;
  }

  String? validateLicenseIssuingAuthority(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "License Issuing Authority is Required";
    } else if (!regExp.hasMatch(value)) {
      return "License Issuing Authority must be a-z and A-Z";
    }
    return null;
  }

  String? validateLicenseNumber(String value) {
    String pattern = r'^\([A-Za-z0-9\-\/]+\)$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "License Issuing Authority is Required";
    } else if (!regExp.hasMatch(value)) {
      return "License Issuing Authority must be a-z and A-Z";
    }
    return null;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue? newValue) {
    return TextEditingValue(
      text: newValue?.text.toUpperCase() ?? '',
      selection: newValue!.selection,
    );
  }
}
