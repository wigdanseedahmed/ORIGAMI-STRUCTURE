class UserIDValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "User Model ID can't be empty";
    }
    if(value.length < 2) {
      return "User Model ID must be at least 2 characters long";
    }
    if(value.length > 50) {
      return "User Model ID must be less than 50 characters long";
    }
    return null;
  }
  //TODO: Add search through database to see if user ID exists or not
}

class NameValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}


class PasswordValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Password can't be empty";
    } else if(value.length < 8){
      return 'Password Should be at least 8 characters ';
    }
    return null;
  }
}

class TaskTitleValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class TaskDescriptionValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 1000) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class TaskDueDateValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class TaskDueTimeValidator {
  static String? validate(String value) {
    if(value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}