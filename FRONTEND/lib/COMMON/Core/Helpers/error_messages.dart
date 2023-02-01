class RegistrationOrLogInErrors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "This e-mail address is already in use, please use a different e-mail address.";

      case 'ERROR_INVALID_EMAIL':
        return "Your email address appears to be malformed.";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";

      case 'ERROR_WRONG_PASSWORD':
        return "E-mail address or password is incorrect.";

      case "ERROR_USER_NOT_FOUND":
        return "User Model with this email doesn't exist.";

      case "ERROR_USER_DISABLED":
        return  "User Model with this email has been disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";

      case "ERROR_OPERATION_NOT_ALLOWED":
        return  "Signing in with Email and Password is not enabled.";

      default:
        return "An undefined Error happened.";
    }
  }
}

class ProfileDataFormErrors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "This e-mail address is already in use, please use a different e-mail address.";
    default:
        return "An undefined Error happened.";
    }
  }
}