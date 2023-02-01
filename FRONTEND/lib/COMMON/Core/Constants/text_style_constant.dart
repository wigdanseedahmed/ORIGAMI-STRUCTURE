import 'package:origami_structure/imports.dart';

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kContentLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
);

const kMessageTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.black,
);

const kDisplayEmailInRegistrationLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const kDisplayUsernameInRegistrationLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const kLabelTextBoldStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
  fontWeight: FontWeight.bold,
);

const kDropDownTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFF8D8E98),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.purple,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kFlatIconButton = TextStyle(
  fontSize: 20.0,
);

const kProfileHeaderTextStyle = TextStyle(
  fontSize: 24,
  height: 1.4,
  fontWeight: FontWeight.bold,
);

const kProfileHeaderTextStyleV2 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Color(0xFF999999),
); //IF WE USE HEADERS OUTSIDE OF SHADED AREA

var kProfileSubHeaderDetailTextStyle = TextStyle(
  fontSize: 14,
  height: 1.4,
  fontWeight: FontWeight.w600,
  fontStyle: FontStyle.italic,
  color: primaryColour,
);

const kProfileMidSubHeaderTextStyle = TextStyle(
  fontSize: 20,
  height: 1.4,
  fontWeight: FontWeight.w800,
);

const kProfileSubHeaderTextStyle = TextStyle(
  fontSize: 18,
  height: 1.4,
  fontWeight: FontWeight.w800,
);

const kProfileBodyTextStyle = TextStyle(fontSize: 14, height: 1.4);

TextStyle get headingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
  );
}

TextStyle get titleTextStyleMA {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16, color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}
TextStyle get titleTextStyleWS {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16, color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subTitleTextStyleMA {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700]),
  );
}

TextStyle get subTitleTextStyleWS {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700]),
  );
}

TextStyle get bodyTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get body2TextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[600]),
  );
}

const kHeadNotificationTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kSubNotificationTextStyle = TextStyle(
  fontSize: 18.0,
  color: kLightNotificationColor,
);

const kTitleNotificationTextStyle = TextStyle(
  fontSize: 20.0,
  color: kPrimaryNotificationColor,
);

const kDarkNotificationTextStyle = TextStyle(
  fontSize: 20.0,
  color: kDarkNotificationColor,
);
