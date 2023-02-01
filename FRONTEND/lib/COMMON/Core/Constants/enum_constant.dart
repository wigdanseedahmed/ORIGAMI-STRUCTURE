enum UserType {
  technician,
  seniorProjectManager,
  projectManager,
  projectCoordinator,
  projectMember,
  unknown,
}

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

enum ReturnType {
  // ignore: constant_identifier_names
  EMAILERROR, SUCCESS
}

class UserTypeHelper {
  static String getValue(UserType userType) {
    switch (userType) {
      case UserType.technician:
        return "Technician";
      case UserType.seniorProjectManager:
        return "Senior Project Manager";
      case UserType.projectManager:
        return "Project Manager";
      case UserType.projectCoordinator:
        return "Project Coordinator";
      case UserType.projectMember:
        return "Project Member";
      default:
        return 'UNKNOWN';
    }
  }

  static UserType getEnum(String userType) {
    if (userType == getValue(UserType.technician)) {
      return UserType.technician;
    } else if (userType == getValue(UserType.seniorProjectManager)) {
      return UserType.seniorProjectManager;
    } else if (userType == getValue(UserType.projectManager)) {
      return UserType.projectManager;
    } else if (userType == getValue(UserType.projectCoordinator)) {
      return UserType.projectCoordinator;
    } else if (userType == getValue(UserType.projectMember)) {
      return UserType.projectMember;
    }  else {
      return UserType.unknown;
    }
  }
}

enum AuthStatus {
  notLoggedIn,
  loggedIn,
}

enum AuthErrors {
  // ignore: constant_identifier_names
  UserNotFound,
  // ignore: constant_identifier_names
  PasswordNotValid,
  // ignore: constant_identifier_names
  NetworkError,
  // ignore: constant_identifier_names
  SUCCESS,
  // ignore: constant_identifier_names
  TOOMANYATTEMPTS,
  // ignore: constant_identifier_names
  UNKNOWN
}

class AuthErrorsHelper {
  static String getValue(AuthErrors authError) {
    switch (authError) {
      case AuthErrors.UserNotFound:
        return "No such User Model Found";
      case AuthErrors.PasswordNotValid:
        return "Password is not valid";
      case AuthErrors.NetworkError:
        return "A network error has occurred, please try again";
      case AuthErrors.SUCCESS:
        return "Task performed succesfully";
      case AuthErrors.UNKNOWN:
        return "Something went wrong!";
      case AuthErrors.TOOMANYATTEMPTS:
        return "Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later";
      default:
        return "opps, please Try again";
    }
  }
}

enum LoginType {
  email,
  google,
}

enum PopupMenuOptions {
  about,
  moveList,
  copy,
  archiveProject,
  watch,
}

enum MenuState {
  dashboardScreen,
  weeklyMeetingReportScreen,
  projectScreen,
  navigatorScreen, //ProfileScreen(),
  settingsScreen,
}

enum NavigationMenu {
  dashboardScreen,
  weeklyMeetingReportScreen,
  projectBoardScreen,
  projectScreen,
  taskCalendarScreen,
}